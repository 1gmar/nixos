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
  hiragino-typeface = pkgs.callPackage ./packages/hiragino.nix {};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
  };

  console = {
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
    font = "ter-u18b";
    packages = [pkgs.terminus_font];
    keyMap = "us";
  };

  environment = {
    systemPackages = with pkgs; [
      alejandra
      dmidecode
      feh
      lm_sensors
      pavucontrol
      statix
      telegram-desktop
      wthrr
    ];
    variables = {
      GLFW_IM_MODULE = "ibus";
    };
  };

  fonts = {
    fontconfig.defaultFonts = {
      emoji = [
        "Noto Color Emoji"
      ];
      monospace = [
        "Fira Mono"
        "Noto Sans Mono CJK JP"
      ];
      sansSerif = [
        "Fira Sans"
        "Noto Sans CJK JP"
      ];
      serif = [
        "Fira Sans"
        "Noto Serif CJK JP"
      ];
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      cantarell-fonts
      corefonts
      dejavu_fonts
      fira
      hiragino-typeface
      jetbrains-mono
      liberation_ttf
      material-design-icons
      meslo-lgs-nf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      unifont
      unifont_upper
      vistafonts
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs system wallpaperPath;};
    sharedModules = [
      inputs.self.outputs.homeManagerModules.default
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${userName} = import ./home.nix;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [mozc];
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  main-user = {
    enable = true;
    description = "Igor Marta";
    userName = "${userName}";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "corefonts"
      "vista-fonts"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

  # Enable the X11 windowing system.
  services = {
    displayManager = {
      defaultSession = "none+i3";
      sddm.enable = true;
    };
    libinput.mouse = {
      accelProfile = "flat";
      naturalScrolling = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    openssh.enable = true;
    xserver = {
      enable = true;
      exportConfiguration = true;
      videoDrivers = ["nvidia"];
      windowManager.i3.enable = true;
      xkb = {
        layout = "us,ro,ru";
        variant = ",std,phonetic_YAZHERTY";
        options = "grp:win_space_toggle,grp:ctrl_alt_toggle_bidir";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Chisinau";

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
  system.stateVersion = "24.11"; # Did you read the comment?
}
