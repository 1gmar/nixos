export def color-config [colors: record] {
  let background = $colors.background;
  let blue = $colors.blue;
  let cyan = $colors.cyan;
  let green = $colors.green;
  let red = $colors.red;
  let violet = $colors.violet;
  let yellow = $colors.yellow;
  let highlight = $colors.highlight;
  let black = $colors.brightBlack;

  return {
    binary: $violet
    block: $blue
    cell-path: $highlight
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

    bool: { if $in { $green } else { $red } }

    datetime: {
      (date now) - $in
      | if $in < 1hr {
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
        $highlight
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
    shape_garbage: {fg: $background bg: $colors.magenta attr: b}
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

    foreground: $colors.primaryContent
    background: $background
    cursor: $highlight

    empty: $blue
    header: {fg: $green attr: b}
    hints: $colors.brightBlue
    leading_trailing_space_bg: {attr: n}
    row_index: {fg: $green attr: b}
    search_result: {fg: $red bg: $colors.backHighlight attr: bu}
    separator: $highlight
  }
}
