$env.PROMPT_COMMAND = {|| get-prompt-text }
$env.PROMPT_COMMAND_RIGHT = {|| get-right-prompt-text }
$env.PROMPT_INDICATOR = {|| $"(get-indicator-color)❯ " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| $"(get-indicator-color)❯ " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(get-indicator-color)❮ " }
$env.PROMPT_MULTILINE_INDICATOR = "> "

def get-prompt-text []: nothing -> string {
  let os_segment = (get-os-segment)
  let path_segment = (get-path-segment)

  $"($os_segment) ($path_segment) "
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
  let basename_color = ansi {fg: deepskyblue1, attr: b}
  let dir = (get-dir-metadata | update icon { $"($path_color)($in)" })
  let basename = $"($basename_color)($dir.path | path basename)"
  let dirname = ($dir.path | get-dirname $path_color)

  $"($dir.icon) ($dirname | path join $basename)"
}

def get-dir-metadata []: nothing -> record<path: string, icon: string> {
  match (do -i { $env.PWD | path relative-to $nu.home-path }) {
    null => {path: $env.PWD, icon: (if (is-admin) { '' } else { '' })}
    '' => {path: '~', icon: (if (is-admin) { '󰣬' } else { '' })}
    $relative_pwd => {path: ([~ $relative_pwd] | path join), icon: (if (is-admin) { '󰴉' } else { '' })}
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
  let exec_duration = ($env.CMD_DURATION_MS
    | into int
    | $in // 1000
    | if $in > 3600 { ($in // 60 | into duration --unit min) } else { ($in | into duration --unit sec) }
  )

  if $exec_duration >= 3sec {
    $"(ansi darkseagreen4a) ($exec_duration)"
  }
}

