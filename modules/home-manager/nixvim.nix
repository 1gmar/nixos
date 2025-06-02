{
  config,
  inputs,
  lib,
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
        nixpkgs.expr = lib.mkForce "import (builtins.getFlake \"${config.home.homeDirectory}/nixos\").inputs.nixpkgs { }";
        options.nixos.expr = "(builtins.getFlake \"${config.home.homeDirectory}/nixos\").nixosConfigurations.desktop.options";
      };
    };
  };
}
