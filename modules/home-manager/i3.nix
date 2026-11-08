{ lib, ... }:
{
  options.i3.extraConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };
  config = { };
}
