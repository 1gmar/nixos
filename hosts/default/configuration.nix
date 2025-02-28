{
  config,
  lib,
  pkgs,
  inputs,
  system,
  wallpaperPath,
  ...
}: let
  userName = "igmar";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # Set your time zone.
  time.timeZone = "Europe/Chisinau";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-u18b";
    #   keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
    packages = [pkgs.terminus_font];
    colors = [
      "fdf6e3"
      "dc322f"
      "859900"
      "b58900"
      "93a1a1"
      "d33682"
      "2aa198"
      "073642"
      "eee8d5"
      "cb4b16"
      "268bd2"
      "839496"
      "657b83"
      "6c71c4"
      "586e75"
      "002b36"
    ];
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      windowManager.i3.enable = true;
    };
    displayManager = {
      defaultSession = "none+i3";
      sddm.enable = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  main-user = {
    enable = true;
    userName = "${userName}";
    description = "Igor Marta";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs system;};
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.self.outputs.homeManagerModules.default
    ];
    users.${userName} = import ./home.nix;
  };

  environment.systemPackages = with pkgs; [
    alejandra
    nixd
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
