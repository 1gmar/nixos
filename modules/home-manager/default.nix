{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./activity-watch.nix
    ./bash.nix
    ./dconf.nix
    ./direnv.nix
    ./dunst.nix
    ./gammastep.nix
    ./git.nix
    ./i3.nix
    ./kitty.nix
    ./librewolf.nix
    ./nixvim.nix
    ./polybar.nix
    ./rofi.nix
    ./screen-locker.nix
    ./ssh.nix
    ./thunderbird.nix
    ./vim.nix
  ];
}
