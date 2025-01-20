{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./home-stylix.nix
    ./bash.nix
    ./vim.nix
    ./nixvim.nix
    ./kitty.nix
    ./i3.nix
    ./git.nix
    ./direnv.nix
    ./ssh.nix
  ];
}
