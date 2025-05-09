{inputs, ...}: {
  imports = [
    inputs.nixvim-1gmar.homeManagerModules.nixvim
    ./activity-watch.nix
    ./bash.nix
    ./dconf.nix
    ./direnv.nix
    ./dunst.nix
    ./firefox.nix
    ./gammastep.nix
    ./git.nix
    ./i3.nix
    ./kitty.nix
    ./librewolf.nix
    ./nixvim.nix
    ./picom.nix
    ./polybar.nix
    ./rofi.nix
    ./screen-locker.nix
    ./ssh.nix
    ./thunderbird.nix
    ./vim.nix
  ];
}
