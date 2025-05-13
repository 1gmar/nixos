{
  inputs,
  lib,
  config,
  ...
}: {
  options.nixvim = {
    enable = lib.mkEnableOption "enable nixvim module";
  };
  config = lib.mkIf config.nixvim.enable {
    programs.nixvim = {
      enable = true;
      imports = [inputs.nixvim-1gmar.nixvimModule];
      plugins.lsp.servers.nixd.settings = {
        nixpkgs.expr = lib.mkForce "import (builtins.getFlake \"github:1gmar/nixos/86fe5baf99156893b37280aef324c15cbea32a6a\").inputs.nixpkgs { }";
        options.nixos.expr = "(builtins.getFlake \"github:1gmar/nixos/86fe5baf99156893b37280aef324c15cbea32a6a\").nixosConfigurations.desktop.options";
      };
    };
  };
}
