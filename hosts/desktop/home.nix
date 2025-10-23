{
  sysConfig,
  userName,
  ...
}:
{
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
    };
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  activity-watch.enable = true;
  bash.enable = true;
  bat.enable = true;
  direnv.enable = true;
  dunst.enable = true;
  fastfetch.enable = true;
  feh.enable = true;
  firefox.enable = true;
  flameshot.enable = true;
  flatpak.enable = sysConfig.flatpak.enable;
  foliate.enable = true;
  gammastep.enable = true;
  git.enable = true;
  i3wm.enable = true;
  ibus.enable = sysConfig.ibus.enable;
  keepassxc.enable = true;
  kitty.enable = true;
  kodi.enable = false;
  media-keys.enable = true;
  nixvim.enable = true;
  nushell.enable = true;
  picom.enable = true;
  polybar.enable = true;
  rofi.enable = true;
  screen-locker.enable = sysConfig.screen-locker.enable;
  ssh.enable = true;
  thunderbird.enable = true;
  translate-selected.enable = true;
  vim.enable = true;
  wthrr.enable = true;
}
