{ userName, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  audio.enable = true;
  boot-config = {
    enable = true;
    kernelModules = [
      "coretemp"
      "nct6775"
    ];
  };
  console-config = {
    enable = true;
    font = "ter-v18b";
  };
  docker.enable = true;
  flatpak.enable = true;
  font-config = {
    enable = true;
    extra-jp-fonts = true;
  };
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
    sops-pass-key = "user-igmar-password";
  };
  media-server-proxy.enable = true;
  mouse-config.enable = true;
  network-config.enable = true;
  nix-config.enable = true;
  nvidia.enable = true;
  pairdrop.enable = true;
  programs.ssh.startAgent = true;
  screen-locker.enable = true;
  sops.enable = true;
  system-diff.enable = true;
  thunar.enable = true;
  unfree-apps.enable = true;
  xserver.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
