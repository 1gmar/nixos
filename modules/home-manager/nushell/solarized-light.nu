export-env {
  $env.config.color_config = gen-config ($env.TERM == 'linux')
}

def gen-config [is_tty: bool]: nothing -> record {
  {
    binary: 'light_magenta'
    block: 'blue'
    cell-path: 'light_green'
    closure: 'cyan'
    custom: (if $is_tty { 'light_gray' } else { 'dark_gray' })
    duration: 'yellow'
    float: 'red'
    glob: (if $is_tty { 'light_gray' } else { 'dark_gray' })
    int: 'light_magenta'
    list: 'cyan'
    nothing: 'red'
    range: 'yellow'
    record: 'cyan'
    string: 'green'

    bool: { if $in { 'green' } else { 'red' } }

    datetime: {
      (date now) - $in
      | if $in < 1hr {
        {fg: 'red' attr: b}
      } else if $in < 6hr {
        'red'
      } else if $in < 1day {
        'yellow'
      } else if $in < 3day {
        'green'
      } else if $in < 1wk {
        {fg: 'green' attr: b}
      } else if $in < 6wk {
        'cyan'
      } else if $in < 52wk {
        'blue'
      } else { 'light_magenta' }
    }

    filesize: {|e|
      if $e == 0b {
        'light_green'
      } else if $e < 1mb {
        'cyan'
      } else { 'blue' }
    }

    shape_and: (if $is_tty { 'light_magenta' } else { {fg: 'light_magenta' attr: b} })
    shape_binary: (if $is_tty { 'light_magenta' } else { {fg: 'light_magenta' attr: b} })
    shape_block: (if $is_tty { 'blue' } else { {fg: 'blue' attr: b} })
    shape_bool: 'cyan'
    shape_closure: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_custom: 'green'
    shape_datetime: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_directory: 'cyan'
    shape_external: 'cyan'
    shape_external_resolved: 'cyan'
    shape_externalarg: (if $is_tty { 'green' } else { {fg: 'green' attr: b} })
    shape_filepath: 'cyan'
    shape_flag: (if $is_tty { 'blue' } else { {fg: 'blue' attr: b} })
    shape_float: (if $is_tty { 'red' } else { {fg: 'red' attr: b} })
    shape_garbage: (if $is_tty { {fg: 'black' bg: 'magenta'} } else { {fg: 'light_gray' bg: 'magenta' attr: b} })
    shape_glob_interpolation: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_globpattern: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_int: (if $is_tty { 'light_magenta' } else { {fg: 'light_magenta' attr: b} })
    shape_internalcall: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_keyword: (if $is_tty { 'light_magenta' } else { {fg: 'light_magenta' attr: b} })
    shape_list: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_literal: 'blue'
    shape_match_pattern: 'green'
    shape_matching_brackets: {attr: u}
    shape_nothing: 'red'
    shape_operator: 'yellow'
    shape_or: (if $is_tty { 'light_magenta' } else { {fg: 'light_magenta' attr: b} })
    shape_pipe: (if $is_tty { 'light_magenta' } else { {fg: 'light_magenta' attr: b} })
    shape_range: (if $is_tty { 'yellow' } else { {fg: 'yellow' attr: b} })
    shape_raw_string: (if $is_tty { 'light_gray' } else { {fg: 'dark_gray' attr: b} })
    shape_record: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_redirection: (if $is_tty { 'light_magenta' } else { {fg: 'light_magenta' attr: b} })
    shape_signature: (if $is_tty { 'green' } else { {fg: 'green' attr: b} })
    shape_string: 'green'
    shape_string_interpolation: (if $is_tty { 'cyan' } else { {fg: 'cyan' attr: b} })
    shape_table: (if $is_tty { 'blue' } else { {fg: 'blue' attr: b} })
    shape_vardecl: (if $is_tty { 'blue' } else { {fg: 'blue' attr: u} })
    shape_variable: 'light_magenta'

    foreground: 'light_yellow'
    background: (if $is_tty { 'black' } else { 'light_gray' })
    cursor: 'light_green'

    empty: 'blue'
    header: (if $is_tty { 'green' } else { {fg: 'green' attr: b} })
    hints: 'light_blue'
    leading_trailing_space_bg: {attr: n}
    row_index: (if $is_tty { 'green' } else { {fg: 'green' attr: b} })
    search_result: (if $is_tty { 'red' } else { {fg: 'red' bg: 'white' attr: bu} })
    separator: 'light_green'
  }
}
