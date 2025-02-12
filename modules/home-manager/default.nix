{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./bash.nix
    ./direnv.nix
    ./gammastep.nix
    ./git.nix
    ./home-stylix.nix
    ./i3.nix
    ./kitty.nix
    ./nixvim.nix
    ./polybar.nix
    ./rofi.nix
    ./ssh.nix
    ./vim.nix
  ];
}
