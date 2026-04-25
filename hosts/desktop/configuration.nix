{
  pkgs,
  userName,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      adwaita-icon-theme
      calibre
      cryptsetup
      pika-backup
      protonvpn-gui
      qalculate-gtk
      telegram-desktop
    ];
  };

  audio.enable = true;
  boot-config.enable = true;
  console-config.enable = true;
  docker.enable = true;
  flatpak.enable = true;
  font-config.enable = true;
  home-manager-config = {
    enable = true;
    home-file = ./home.nix;
  };
  ibus.enable = true;
  locale.enable = true;
  main-user = {
    enable = true;
    description = "Igor Marta";
    userName = "${userName}";
  };
  media-server-proxy.enable = true;
  mouse.enable = true;
  network-config.enable = true;
  nix-config.enable = true;
  nvidia.enable = true;
  pairdrop.enable = true;
  screen-locker.enable = true;
  system-diff.enable = true;
  thunar.enable = true;
  unfree-apps.enable = true;
  xserver.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
