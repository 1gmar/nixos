$env.config.keybindings ++= [
  {
    name: clear_screen_with_scrollback
    modifier: Control
    keycode: Char_l
    mode: [Emacs Vi_Normal Vi_Insert]
    event: [
      {send: ClearScreen}
      {send: ClearScrollback}
    ]
  }
]
