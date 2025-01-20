{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    nixvim.enable = lib.mkEnableOption "enable nixvim module";
  };
  config = lib.mkIf config.nixvim.enable {
    programs.nixvim = let
      nixvim = (import ../exposed/nixvim.nix) {inherit config lib pkgs;};
    in
      with nixvim.config; {
        inherit colorscheme globals keymaps opts extraConfigLuaPost extraConfigVim extraPlugins plugins;
        enable = true;
      };
  };
}
