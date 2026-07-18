{ ... }:
{
  imports = [
    ./fonts
    ./sops
    ./system-diff

    ./audio.nix
    ./boot.nix
    ./clight.nix
    ./console.nix
    ./docker.nix
    ./flatpak.nix
    ./home-manager.nix
    ./ibus.nix
    ./locale.nix
    ./main-user.nix
    ./media-server-proxy.nix
    ./mouse.nix
    ./networking.nix
    ./nix.nix
    ./nvidia.nix
    ./pairdrop.nix
    ./screen-locker.nix
    ./screen-scaling.nix
    ./thunar.nix
    ./touchpad.nix
    ./unfree-apps.nix
    ./xserver.nix
  ];
}
