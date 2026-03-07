def main [] { }

def "main up" [] {
  unmute
  adjust-volume 5
}

def "main down" [] {
  unmute
  adjust-volume (-5)
}

def "main mute-toggle" [] {
  wpctl "set-mute" "toggle"
  current-volume | send-notification
}

def adjust-volume [step: int] {
  let volume = current-volume
  let new_volume = $volume + $step
  match $new_volume {
    0..100 => {
      set-volume $new_volume
      $new_volume
    }
    _ => $volume
  } | send-notification
}

def current-volume []: nothing -> int {
  wpctl "get-volume"
  | split words
  | skip
  | match $in {
    ['0' $v] => ($v | into int)
    ['1' _] => 100
    [_ _ 'MUTED'] => 0
  }
}

def send-notification []: int -> nothing {
  let icon = match $in {
    0 => "muted"
    1..30 => "low"
    31..60 => "medium"
    61..99 => "high"
    100 => "overamplified"
  }
  dunstify -a "Volume" -i $"audio-volume-($icon)-symbolic" -h $"int:value:($in)" -u "low" "blank"
}

def set-volume [value: int] {
  wpctl "set-volume" $"($value / 100)"
}

def unmute [] {
  wpctl "set-mute" 0
}

def wpctl [sub_cmd: string cmd_opt?: string] {
  ^wpctl $sub_cmd "@DEFAULT_AUDIO_SINK@" ($cmd_opt | default "")
}
