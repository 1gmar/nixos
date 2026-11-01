export-env {
  $env.PROMPT_COMMAND = { get-prompt-text }
  $env.TRANSIENT_PROMPT_COMMAND = ""
  $env.PROMPT_COMMAND_RIGHT = { get-right-prompt-text }
  $env.TRANSIENT_PROMPT_COMMAND_RIGHT = { get-execution-segment }
  $env.PROMPT_INDICATOR = { $"(icon prompt_arrow_right | color (get-indicator-color)) " }
  $env.PROMPT_INDICATOR_VI_INSERT = { $"(icon prompt_arrow_right | color (get-indicator-color)) " }
  $env.PROMPT_INDICATOR_VI_NORMAL = { $"(icon prompt_arrow_left | color (get-indicator-color)) " }
  $env.PROMPT_MULTILINE_INDICATOR = "> "
}

const icon_table = [
  [key val];
  [prompt_arrow_right ['❯' '›']]
  [prompt_arrow_left ['❮' '‹']]
  [branch ['' 'Ч']]
  [git_tag [' ' '@']]
  [git_stash ['󰴮 ' '* ']]
  [github [' ' '']]
  [gitlab [' ' '']]
  [codeberg [' ' '']]
  [bitbucket ['' '']]
  [repo_default ['󰳏' '']]
  [cherrypick [' ' '‰']]
  [merge ['' 'λ']]
  [rebase ['' '↓↑']]
  [revert ['󰕍 ' '«']]
  [conflicts ['󰮘 ' '× ']]
  [staged_changes ['󰈖 ' '+ ']]
  [unstaged_changes ['󰩋 ' '! ']]
  [untracked ['󰡯 ' '? ']]
  [unlocked [' ' '#']]
  [locked [' ' '■']]
  [root_home ['󰣬 ' '#']]
  [home [' ' '■']]
  [root_home_path ['󰴉 ' '#']]
  [home_path [' ' '■']]
  [nixos [' ' '']]
  [windows ['󰨡 ' '']]
  [darwin [' ' '']]
  [linux [' ' '']]
  [time ['󱑓 ' '']]
  [duration ['' '']]
]

const color_table = [
  [key val];
  [red1 [red1 red]]
  [chartreuse3b [chartreuse3b green]]
  [deepskyblue3a [deepskyblue3a blue]]
  [deepskyblue1 [{fg: 'deepskyblue1' attr: b} cyan]]
  [nixos ['#7ebae4' blue]]
  [darkseagreen4a [darkseagreen4a green]]
]

def lookup-table [table: table key: string]: nothing -> oneof<record, string> {
  let idx = $env.TERM == 'linux' | into int
  $table | where key == $key | first | get val | get $idx
}

def icon [key: string]: nothing -> string {
  lookup-table $icon_table $key
}

def get-color [key: string]: nothing -> oneof<record, string> {
  lookup-table $color_table $key
}

def color [key: oneof<string, record>]: string -> string {
  $"(ansi $key)($in)(ansi reset)"
}

def get-prompt-text []: nothing -> string {
  let os_segment = get-os-segment
  let path_segment = get-path-segment

  $"($os_segment)($path_segment)"
}

def get-right-prompt-text []: nothing -> string {
  let time_segment = get-time-segment
  let execution_segment = get-execution-segment

  $"($execution_segment) ($time_segment) "
}

def get-indicator-color []: nothing -> string {
  if $env.LAST_EXIT_CODE != 0 {
    'red1'
  } else {
    'chartreuse3b'
  }
}

def get-path-segment []: nothing -> string {
  let path_color = get-color deepskyblue3a
  let dir = get-dir-metadata | update icon { $in | color $path_color }
  let dirpath = $dir.path | get-dirpath $path_color

  $"($dir.icon)($dirpath)"
}

def get-dirpath [path_color: string]: string -> string {
  let dirpath = $in
  let basename_color = get-color deepskyblue1
  if $dirpath !~ '^~' {
    return ($dirpath | get-default-dirpath $path_color $basename_color)
  }
  let gs = gstat
  if $gs.state == 'no_state' {
    return ($dirpath | get-default-dirpath $path_color $basename_color)
  }
  let repo_folder = git rev-parse --show-toplevel | path basename
  let repo_prefix = $dirpath | path split | take until { $in == $repo_folder } | path join
  let git_dirpath = $dirpath | path relative-to $repo_prefix
  let gs_summary = summarize-gs $gs
  let git_branch_section = [
    (get-git-remote-icon)
    $"(icon branch)($gs.branch)"
    (if $gs.tag != 'no_tag' { $" (icon git_tag)($gs.tag)" })
    (if not ($gs.remote | str ends-with $gs.branch) { $":($gs.remote)" })
    (if $gs.behind > 0 or $gs.ahead > 0 { ' ' })
    (if $gs.behind > 0 { $"(char branch_behind)($gs.behind)" })
    (if $gs.ahead > 0 { $"(char branch_ahead)($gs.ahead)" })
    ' '
    (if $gs.stashes > 0 { $"($gs.stashes)(icon git_stash)" })
  ] | str join | color (get-color chartreuse3b)
  [
    ($git_dirpath | get-default-dirpath $path_color $basename_color)
    ' '
    $git_branch_section
    ($gs.state | decorate-git-state)
    (if $gs.conflicts > 0 { $"($gs.conflicts)(icon conflicts)" | color red })
    (if $gs_summary.staged_changes > 0 { $"($gs_summary.staged_changes)(icon staged_changes)" | color green })
    (if $gs_summary.unstaged_changes > 0 { $"($gs_summary.unstaged_changes)(icon unstaged_changes)" | color yellow })
    (if $gs.wt_untracked > 0 { $"($gs.wt_untracked)(icon untracked)" | color blue })
  ]
  | str join
}

def summarize-gs [gs] {
  {
    staged_changes : (
      [
        $gs.idx_added_staged
        $gs.idx_renamed
        $gs.idx_modified_staged
        $gs.idx_deleted_staged
      ] | math sum
    )
    unstaged_changes : (
      [
        $gs.wt_modified
        $gs.wt_deleted
        $gs.wt_renamed
      ] | math sum
    )
  }
}

def get-git-remote-icon []: nothing -> string {
  git config get remote.origin.url
  | parse -r '^(?:git@|https?://)(?<remote>\w+)\..+$'
  | get remote.0
  | if $in in ['github' 'gitlab' 'codeberg' 'bitbucket'] { icon $in } else { icon repo_default }
}

def decorate-git-state []: string -> string {
  match $in {
    'clean' => ''
    'cherrypick' => (icon cherrypick | color cyan)
    'merge' => (icon merge | color red)
    'rebase' => (icon rebase | color blue)
    'revert' => (icon revert | color yellow)
    _ => ($in | color default)
  }
}

def get-default-dirpath [path_color: string basename_color: oneof<record, string>]: string -> string {
  let dirpath = $in
  let basename = $dirpath | path basename | color $basename_color
  let dirname = $dirpath | get-dirname $path_color
  if ($dirname | is-empty) {
    $basename
  } else {
    $"($dirname)((char separator) | color $path_color)($basename)"
  }
}

def get-dir-metadata []: nothing -> record<path: string, icon: string> {
  match (do -i { $env.PWD | path relative-to $nu.home-dir }) {
    null => {path: $env.PWD icon: (if (is-admin) { icon unlocked } else { icon locked })}
    '' => {path: '~' icon: (if (is-admin) { icon root_home } else { icon home })}
    $relative_pwd => {
      path: ([~ $relative_pwd] | path join)
      icon: (if (is-admin) { icon root_home_path } else { icon home_path })
    }
  }
}

def get-dirname [path_color: string]: string -> string {
  $in
  | path dirname
  | if ($in | is-empty) { '' } else { $in | color $path_color }
}

def get-os-segment []: nothing -> string {
  match (sys host | get name) {
    'NixOS' => (icon nixos | color (get-color nixos))
    'Windows' => (icon windows)
    'Darwin' => (icon darwin)
    _ => (icon linux)
  }
}

def get-time-segment []: nothing -> string {
  $"(icon time)(date now | format date '%H:%M:%S')" | color magenta
}

def get-execution-segment []: nothing -> duration {
  let exec_duration = $env.CMD_DURATION_MS
    | into int
    | $in // 1000
    | if $in < 3600 {
      $in | into duration --unit sec
    } else {
      $in // 60 | into duration --unit min
    }

  if $exec_duration >= 3sec {
    $"(icon duration) ($exec_duration)" | color (get-color darkseagreen4a)
  }
}
