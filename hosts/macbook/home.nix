{
  config,
  lib,
  pkgs,
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
    shell.enableShellIntegration = false;
    stateVersion = "26.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  activity-watch.enable = false;
  bash.enable = true;
  bat.enable = true;
  carapace.enable = true;
  direnv.enable = true;
  dunst.enable = true;
  fastfetch.enable = true;
  feh.enable = true;
  firefox.enable = true;
  flameshot.enable = false;
  flatpak.enable = sysConfig.flatpak.enable;
  foliate.enable = false;
  git.enable = true;
  i3wm.enable = true;
  ibus.enable = sysConfig.ibus.enable;
  jellyfin-desktop.enable = false;
  keepassxc.enable = true;
  kitty.enable = true;
  kodi.enable = false;
  media-keys.enable = true;
  nixvim.enable = true;
  nushell.enable = true;
  picom.enable = true;
  pointer-cursor = {
    enable = true;
    size = 32;
  };
  polybar = {
    enable = true;
    battery.enable = true;
    height = "2.25%";
    icon-voffset = 7;
    text-voffset = 5;
    cpu.fan-cmd =
      "${config.home.profileDirectory}/bin/nu -c "
      + "'${pkgs.lm_sensors}/bin/sensors | find `Left side` | split row -r `\\s+` | get 3'";
    gpu = {
      radeongpu.enable = true;
      fan-cmd.exec =
        "${config.home.profileDirectory}/bin/nu -c "
        + "'${pkgs.lm_sensors}/bin/sensors | find `Right side` | split row -r `\\s+` | get 3'";
      temp-cmd.exec =
        "${config.home.profileDirectory}/bin/nu -c "
        + "'${pkgs.lm_sensors}/bin/sensors | find `temp1` | split row -r `\\s+` "
        + "| get 1 | str replace -a -r `(\\+|\\.\\d°C)` ``'";
    };
    network.interface = "wlp4s0";
    weather.enable = false;
    workspaces.title-maxlen = 65;
  };
  rofi.enable = true;
  screen-locker.enable = sysConfig.screen-locker.enable;
  ssh.enable = false;
  thunderbird.enable = true;
  translate-selected.enable = false;
  vim.enable = false;
  wthrr.enable = true;
  xresources.properties = lib.mkIf (sysConfig.screen-scaling.enable && sysConfig.xserver.enable) {
    "Xft.dpi" = sysConfig.screen-scaling.dpi;
  };
}
