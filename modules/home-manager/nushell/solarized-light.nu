export def main [] {
  let background = '#fdf6e3'
  let backgroundHigh = '#eee8d5'
  let blue = '#268bd2'
  let cyan = '#2aa198'
  let green = '#859900'
  let magenta = '#d33682'
  let orange = '#cb4b16'
  let red = '#dc322f'
  let violet = '#6c71c4'
  let yellow = '#b58900'
  let text = '#657b83'
  let textEmph = '#586e75'
  let black = '#002b36'
  let base = '#839496'

  return {
    binary: $violet
    block: $blue
    cell-path: $textEmph
    closure: $cyan
    custom: $black
    duration: $yellow
    float: $red
    glob: $black
    int: $violet
    list: $cyan
    nothing: $red
    range: $yellow
    record: $cyan
    string: $green

    bool: {|| if $in { $green } else { $red } }

    datetime: {|| (date now) - $in |
      if $in < 1hr {
        {fg: $red attr: b}
      } else if $in < 6hr {
        $red
      } else if $in < 1day {
        $yellow
      } else if $in < 3day {
        $green
      } else if $in < 1wk {
        {fg: $green attr: b}
      } else if $in < 6wk {
        $cyan
      } else if $in < 52wk {
        $blue
      } else { $violet }
    }

    filesize: {|e|
      if $e == 0b {
        $textEmph
      } else if $e < 1mb {
        $cyan
      } else { {fg: $blue} }
    }

    shape_and: {fg: $violet attr: b}
    shape_binary: {fg: $violet attr: b}
    shape_block: {fg: $blue attr: b}
    shape_bool: $cyan
    shape_closure: {fg: $cyan attr: b}
    shape_custom: $green
    shape_datetime: {fg: $cyan attr: b}
    shape_directory: $cyan
    shape_external: $cyan
    shape_external_resolved: $cyan
    shape_externalarg: {fg: $green attr: b}
    shape_filepath: $cyan
    shape_flag: {fg: $blue attr: b}
    shape_float: {fg: $red attr: b}
    shape_garbage: {fg: $background bg: $magenta attr: b}
    shape_glob_interpolation: {fg: $cyan attr: b}
    shape_globpattern: {fg: $cyan attr: b}
    shape_int: {fg: $violet attr: b}
    shape_internalcall: {fg: $cyan attr: b}
    shape_keyword: {fg: $violet attr: b}
    shape_list: {fg: $cyan attr: b}
    shape_literal: $blue
    shape_match_pattern: $green
    shape_matching_brackets: {attr: u}
    shape_nothing: $red
    shape_operator: $yellow
    shape_or: {fg: $violet attr: b}
    shape_pipe: {fg: $violet attr: b}
    shape_range: {fg: $yellow attr: b}
    shape_raw_string: {fg: $black attr: b}
    shape_record: {fg: $cyan attr: b}
    shape_redirection: {fg: $violet attr: b}
    shape_signature: {fg: $green attr: b}
    shape_string: $green
    shape_string_interpolation: {fg: $cyan attr: b}
    shape_table: {fg: $blue attr: b}
    shape_vardecl: {fg: $blue attr: u}
    shape_variable: $violet

    foreground: $textEmph
    background: $background
    cursor: $textEmph

    empty: $blue
    header: {fg: $green attr: b}
    hints: $base
    leading_trailing_space_bg: {attr: n}
    row_index: {fg: $green attr: b}
    search_result: {fg: $red bg: $backgroundHigh attr: bu}
    separator: $textEmph
  }
}

# Update the Nushell configuration
export def --env "set color_config" [] {
  $env.config.color_config = (main)
}

# Update terminal colors
export def "update terminal" [] {
  let theme = (main)

  # Set terminal colors
  let osc_screen_foreground_color = '10;'
  let osc_screen_background_color = '11;'
  let osc_cursor_color = '12;'

  $"
  (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
  (ansi -o $osc_screen_background_color)($theme.background)(char bel)
  (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
  "
  # Line breaks above are just for source readability
  # but create extra whitespace when activating. Collapse
  # to one line and print with no-newline
  | str replace --all "\n" ''
  | print -n $"($in)\r"
}

export module activate {
  export-env {
    set color_config
    update terminal
  }
}

# Activate the theme when sourced
use activate
