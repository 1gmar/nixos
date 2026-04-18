{ ... }:
{
  imports = [
    ./fonts

    ./docker.nix
    ./flatpak.nix
    ./ibus.nix
    ./main-user.nix
    ./media-server-proxy.nix
    ./nvidia.nix
    ./pairdrop.nix
    ./screen-locker.nix
    ./thunar.nix
    ./unfree-apps.nix
  ];
}
