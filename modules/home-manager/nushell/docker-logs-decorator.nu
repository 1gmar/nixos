def main []: any -> nothing {
  for line in ($in | lines) {
    $line | decorate-line | print
  }
}

def decorate-line []: string -> string {
  let docker_timestamp = '\d{4}-\d{2}-\d{2}T\d{1,2}:\d{2}:\d{2}\.\d+Z'
  let service_timestamp = '\d{4}[-/]\d{2}[-/]\d{2}[ T]\d{1,2}:\d{2}(?::\d{2})*(?:\+\d{2}:\d{2})*(?:AM|PM)*'
  let service_time = '\[\d{2}:\d{2}:\d{2}\]'
  let log_columns = $in
    | ansi strip
    | parse -r (
      '^(?<prefix>\w+\s+\|\s*|\w+\s+)'
      + '(?<timestamp>' + $docker_timestamp + ')*\s*'
      + '(?:' + $service_timestamp + '|' + $service_time + ')*\s*'
      + '(?<logline>.+)$'
    )

  let ts_col = $log_columns.timestamp.0
  let timestamp = if ($ts_col | is-not-empty) {
    $ts_col
    | into datetime
    | date to-timezone local
    | format date "%Y-%m-%d %H:%M:%S "
  }
  let prefix_col = $log_columns.prefix.0
  let log_color = $prefix_col
    | split row -r '\s+'
    | get 0
    | color-line

  $"($log_color)(ansi bo)($prefix_col)($timestamp)($log_columns.logline.0)"
}

def color-line []: string -> string {
  match $in {
    'flaresolverr' => (ansi darkgoldenrod)
    'gluetun' => (ansi light_purple)
    'jellyfin' => (ansi blue)
    'portainer' => (ansi orangered1)
    'prowlarr' => (ansi green)
    'radarr' => (ansi yellow)
    'sonarr' => (ansi cyan)
    'transmission' => (ansi orchid)
    _ => (ansi dark_gray)
  }
}
