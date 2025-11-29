$env.PROMPT_COMMAND = { get-prompt-text }
$env.TRANSIENT_PROMPT_COMMAND = ""
$env.PROMPT_COMMAND_RIGHT = { get-right-prompt-text }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = { (get-execution-segment) }
$env.PROMPT_INDICATOR = { $"(get-indicator-color)❯ " }
$env.PROMPT_INDICATOR_VI_INSERT = { $"(get-indicator-color)❯ " }
$env.PROMPT_INDICATOR_VI_NORMAL = { $"(get-indicator-color)❮ " }
$env.PROMPT_MULTILINE_INDICATOR = "> "

def get-prompt-text []: nothing -> string {
  let os_segment = (get-os-segment)
  let path_segment = (get-path-segment)

  $"($os_segment) ($path_segment)"
}

def get-right-prompt-text []: nothing -> string {
  let time_segment = (get-time-segment)
  let execution_segment = (get-execution-segment)

  $"($execution_segment) ($time_segment) "
}

def get-indicator-color []: nothing -> string {
  if $env.LAST_EXIT_CODE != 0 {
    ansi red1
  } else {
    ansi chartreuse3b
  }
}

def get-path-segment []: nothing -> string {
  let path_color = ansi deepskyblue3a
  let dir = (get-dir-metadata | update icon { $"($path_color)($in)" })
  let dirpath = ($dir.path | get-dirpath $path_color)

  $"($dir.icon) ($dirpath)"
}

def get-dirpath [path_color: string]: string -> string {
  let dirpath = $in
  let basename_color = ansi {fg: deepskyblue1 attr: b}
  if $dirpath !~ '^~' {
    return ($dirpath | get-default-dirpath $path_color $basename_color)
  }
  let gs = (gstat)
  if $gs.state == 'no_state' {
    return ($dirpath | get-default-dirpath $path_color $basename_color)
  }
  let repo_folder = (git rev-parse --show-toplevel | path basename)
  let repo_prefix = ($dirpath | path split | take until { $in == $repo_folder } | path join)
  let git_dirpath = ($dirpath | path relative-to $repo_prefix)
  let gs_summary = (summarize-gs $gs)
  [
    ($git_dirpath | get-default-dirpath $path_color $basename_color)
    $"(ansi chartreuse3b) (get-git-remote-icon)"
    $"(char nf_branch)($gs.branch)"
    (if $gs.tag != 'no_tag' { $"  ($gs.tag)" })
    (if not ($gs.remote | str ends-with $gs.branch) { $":($gs.remote)" })
    (if $gs.behind > 0 or $gs.ahead > 0 { ' ' })
    (if $gs.behind > 0 { $"(char branch_behind)($gs.behind)" })
    (if $gs.ahead > 0 { $"(char branch_ahead)($gs.ahead)" })
    (if $gs_summary.dirty_state { ' ' })
    (if $gs.stashes > 0 { $"($gs.stashes)󰴮 " })
    ($gs.state | decorate-git-state)
    (if $gs.conflicts > 0 { $"(ansi red)($gs.conflicts)󰮘 " })
    (if $gs_summary.staged_changes > 0 { $"(ansi green)($gs_summary.staged_changes)󰈖 " })
    (if $gs_summary.unstaged_changes > 0 { $"(ansi yellow)($gs_summary.unstaged_changes)󰩋 " })
    (if $gs.wt_untracked > 0 { $"(ansi blue)($gs.wt_untracked)󰡯 " })
  ]
  | str join
}

def summarize-gs [gs] {
  let staged_changes = [
    $gs.idx_added_staged
    $gs.idx_renamed
    $gs.idx_modified_staged
    $gs.idx_deleted_staged
  ]
  | math sum
  let unstaged_changes = [
    $gs.wt_modified
    $gs.wt_deleted
    $gs.wt_renamed
  ]
  | math sum
  {
    staged_changes : $staged_changes
    unstaged_changes : $unstaged_changes
    dirty_state : (
      [
        $staged_changes
        $unstaged_changes
        $gs.stashes
        $gs.conflicts
        $gs.wt_untracked
      ]
      | any { $in > 0 }
    )
  }
}

def get-git-remote-icon []: nothing -> string {
  git config get remote.origin.url
  | parse -r '^(?:git@|https?://)(?<remote>\w+)\..+$'
  | get remote.0
  | match $in {
    'github' => ' '
    'gitlab' => ' '
    'codeberg' => ' '
    'bitbucket' => ' '
    _ => '󰳏 '
  }
}

def decorate-git-state []: string -> string {
  match $in {
    'clean' => ''
    'cherrypick' => $" (ansi cyan)"
    'merge' => $" (ansi red)"
    'rebase' => $" (ansi blue)"
    'revert' => $" (ansi yellow)󰕍"
    _ => $" (ansi default)($in)"
  }
}

def get-default-dirpath [path_color: string basename_color: string]: string -> string {
  let dirpath = $in
  let basename = $"($basename_color)($dirpath | path basename)"
  let dirname = ($dirpath | get-dirname $path_color)
  $"($dirname | path join $basename)"
}

def get-dir-metadata []: nothing -> record<path: string, icon: string> {
  match (do -i { $env.PWD | path relative-to $nu.home-path }) {
    null => {path: $env.PWD icon: (if (is-admin) { '' } else { '' })}
    '' => {path: '~' icon: (if (is-admin) { '󰣬' } else { '' })}
    $relative_pwd => {
      path: ([~ $relative_pwd] | path join)
      icon: (if (is-admin) { '󰴉' } else { '' })
    }
  }
}

def get-dirname [path_color: string]: string -> string {
  $in
  | path dirname
  | if ($in | is-empty) { '' } else { $"($path_color)($in)" }
}

def get-os-segment []: nothing -> string {
  match (sys host | get name) {
    'NixOS' => $"(ansi '#7ebae4')"
    'Windows' => '󰨡'
    'Darwin' => ''
    _ => ''
  }
}

def get-time-segment []: nothing -> string {
  $"(ansi reset)(ansi magenta)(date now | format date '󱑓 %H:%M:%S')"
}

def get-execution-segment []: nothing -> duration {
  let exec_duration = (
    $env.CMD_DURATION_MS
    | into int
    | $in // 1000
    | if $in > 3600 {
      ($in // 60 | into duration --unit min)
    } else {
      ($in | into duration --unit sec)
    }
  )

  if $exec_duration >= 3sec {
    $"(ansi darkseagreen4a) ($exec_duration)"
  }
}
