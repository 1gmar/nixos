{ userName, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  audio.enable = true;
  boot-config = {
    enable = true;
    kernelModules = [ "coretemp" ];
  };
  clight.enable = true;
  console-config = {
    enable = true;
    font = "ter-u32b";
    use-xkb-config = true;
  };
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
  location = {
    latitude = 47.0;
    longitude = 28.5;
  };
  main-user = {
    enable = true;
    description = "Igor Marta";
    userName = "${userName}";
    sops-pass-key = "user-igmar-password";
  };
  mouse-config.enable = true;
  network-config = {
    enable = true;
    hostname = "macbook";
  };
  nix-config.enable = true;
  screen-locker = {
    enable = true;
    resolution = "2880x1800";
  };
  screen-scaling = {
    enable = true;
    dpi = 148;
  };
  sops.enable = true;
  system-diff.enable = true;
  thunar.enable = false;
  touchpad-config.enable = true;
  unfree-apps.enable = true;
  xserver = {
    enable = true;
    xkb-options = "ctrl:nocaps,altwin:swap_ralt_rwin";
  };

  programs.ssh.startAgent = true;
  services.openssh.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
