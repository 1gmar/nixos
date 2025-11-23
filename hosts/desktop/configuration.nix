{
  lib,
  pkgs,
  shell-theme,
  sys-diff,
  userName,
  wallpaperPath,
  ...
}:
let
  hiragino-typeface = pkgs.callPackage ./packages/hiragino.nix { };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
      "002b36"
      "dc322f"
      "859900"
      "b58900"
      "268bd2"
      "d33682"
      "2aa198"
      "eee8d5"
      "002b36"
      "cb4b16"
      "586e75"
      "657b83"
      "839496"
      "6c71c4"
      "93a1a1"
      "fdf6e3"
    ];
    font = "ter-u18b";
    packages = [ pkgs.terminus_font ];
    keyMap = "us";
  };

  environment = {
    systemPackages = with pkgs; [
      adwaita-icon-theme
      calibre
      cryptsetup
      dmidecode
      docker-compose
      lm_sensors
      pavucontrol
      pika-backup
      protonvpn-gui
      qalculate-gtk
      telegram-desktop
    ];
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
    packages = with pkgs; [
      cantarell-fonts
      corefonts
      dejavu_fonts
      fira
      hiragino-typeface
      jetbrains-mono
      liberation_ttf
      material-design-icons
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      unifont
      unifont_upper
      vista-fonts
    ];
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
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  networking = {
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -I nixos-fw-log-refuse -s 192.168.100.0/24 -j nixos-fw-accept
      '';
    };
    hostName = "nixos";
    networkmanager.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = "monthly";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "corefonts"
      "vista-fonts"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

  # Enable the X11 windowing system.
  services = {
    displayManager.defaultSession = "none+i3";
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
      config = lib.mkAfter ''
        Section "ServerFlags"
            Option "BlankTime"   "0"
            Option "OffTime"     "0"
            Option "StandbyTime" "0"
            Option "SuspendTime" "0"
        EndSection
      '';
      displayManager.lightdm = {
        background = wallpaperPath;
        enable = true;
        greeters.enso = {
          blur = true;
          enable = true;
        };
      };
      enable = true;
      exportConfiguration = true;
      videoDrivers = [ "nvidia" ];
      windowManager.i3.enable = true;
      xkb.layout = "us";
    };
  };

  system.activationScripts.system-diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nushell}/bin/nu --config ${shell-theme} ${sys-diff} ${userName}\
        ${pkgs.nix}/bin/nix store diff-closures /run/current-system $systemConfig
    fi
  '';

  # Set your time zone.
  time.timeZone = "Europe/Chisinau";

  virtualisation.docker.enable = true;

  flatpak.enable = true;
  ibus.enable = true;
  main-user = {
    enable = true;
    description = "Igor Marta";
    userName = "${userName}";
  };
  media-server-proxy.enable = true;
  pairdrop.enable = true;
  screen-locker.enable = true;
  thunar.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
