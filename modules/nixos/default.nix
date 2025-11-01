{ ... }:
{
  imports = [
    ./flatpak.nix
    ./ibus.nix
    ./main-user.nix
    ./media-server-proxy.nix
    ./pairdrop.nix
    ./screen-locker.nix
    ./thunar.nix
  ];
}
