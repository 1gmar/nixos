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
    };
  };
}
