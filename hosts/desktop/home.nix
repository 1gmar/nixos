{
  config,
  pkgs,
  sysConfig,
  userName,
  ...
}:
{
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    packages = with pkgs; [
      adwaita-icon-theme
      calibre
      pika-backup
      qalculate-gtk
    ];
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
    };
    shell.enableShellIntegration = false;
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  activity-watch.enable = true;
  bash.enable = true;
  bat.enable = true;
  carapace.enable = true;
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
  jellyfin-desktop.enable = true;
  keepassxc.enable = true;
  kitty.enable = true;
  kodi.enable = false;
  media-keys.enable = true;
  nixvim.enable = true;
  nushell.enable = true;
  picom.enable = true;
  pointer-cursor.enable = true;
  polybar = {
    enable = true;
    cpu.fan-cmd =
      if config.nushell.enable then
        "${config.home.profileDirectory}/bin/nu -c "
        + "'${pkgs.lm_sensors}/bin/sensors | find fan2 | split row -r `\\s+` | get 1'"
      else
        "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep fan2 "
        + "| ${pkgs.gawk}/bin/awk '{print $2}'";
    gpu = {
      fan-cmd.exec =
        if config.nushell.enable then
          "${config.home.profileDirectory}/bin/nu -c "
          + "'/run/current-system/sw/bin/nvidia-settings -q GPUCurrentFanSpeedRPM "
          + "| lines | get 1 | split row -r `\\s+` | get 4 | str substring 0..-2'"
        else
          "(set -o pipefail && ${pkgs.lm_sensors}/bin/sensors "
          + "| ${pkgs.gnugrep}/bin/grep fan1 | ${pkgs.gawk}/bin/awk '{print $2}')";
      gpu-cmd.exec =
        if config.nushell.enable then
          "${config.home.profileDirectory}/bin/nu -c "
          + "'/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu,utilization.encoder,utilization.decoder "
          + "--format=csv,noheader,nounits | split row `,` | each { str trim | fill -a right -c ` ` -w 3 } "
          + "| zip [`` `E` `D`] | each { reverse | str join } | update 0 { $in + `%` } | str join ` `'"
        else
          "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu "
          + "--format=csv,noheader,nounits";
      mem-cmd = {
        exec =
          if config.nushell.enable then
            "${config.home.profileDirectory}/bin/nu -c "
            + "'/run/current-system/sw/bin/nvidia-smi --query-gpu=memory.total,memory.used "
            + "--format=csv,noheader | split row `,` | into filesize | $in.1 / $in.0 * 100 | math round'"
          else
            "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.memory "
            + "--format=csv,noheader,nounits";
        interval.text = 1;
      };

      temp-cmd.exec =
        "/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu "
        + "--format=csv,noheader,nounits";
    };
    network.interface = "enp5s0";
  };
  rofi.enable = true;
  screen-locker.enable = sysConfig.screen-locker.enable;
  ssh.enable = false;
  telegram.enable = true;
  thunderbird.enable = true;
  translate-selected.enable = true;
  vim.enable = false;
  wthrr.enable = true;
  xdg.enable = true;
}
