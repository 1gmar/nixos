{
  colors,
  config,
  lib,
  ...
}:
let
  utils = import ../utils.nix { inherit lib; };
  cfg = config.polybar.gpu;
in
{
  imports = [
    ./radeongpu.nix
  ];
  options.polybar.gpu = with lib.types; {
    enable = lib.mkEnableOption "enable polybar gpu module";
    gpu-cmd = lib.mkOption { type = attrsOf anything; };
    fan-cmd = lib.mkOption { type = attrsOf anything; };
    temp-cmd = lib.mkOption { type = attrsOf anything; };
    mem-cmd = lib.mkOption { type = attrsOf anything; };
  };
  config = lib.mkIf cfg.enable {
    polybar = {
      centerModules = lib.mkOrder 1060 [
        "gpu"
        "gpu-fan"
        "gpu-temp"
      ];
      rightModules = lib.mkOrder 1045 [ "gpu-memory" ];
    };
    services.polybar.settings =
      let
        common = {
          type = "custom/script";
          format = {
            fail = "<label-fail>";
            foreground = colors.green;
            text = "<label>";
          };
          interval = {
            fail = "6000";
            text = "0.5";
          };
          label = {
            fail = {
              font = 2;
              foreground = colors.red;
              text = "󱄋";
            };
          };
        };
        modules = [
          {
            name = "module/gpu";
            value = lib.recursiveUpdate {
              format.prefix = {
                font = 2;
                text = "󰢮";
              };
            } cfg.gpu-cmd;
          }
          {
            name = "module/gpu-fan";
            value = lib.recursiveUpdate {
              label.text = "%output:4%";
            } cfg.fan-cmd;
          }
          {
            name = "module/gpu-temp";
            value = lib.recursiveUpdate {
              label.text = "%output:2%°C";
            } cfg.temp-cmd;
          }
          {
            name = "module/gpu-memory";
            value = lib.recursiveUpdate {
              format = {
                foreground = colors.violet;
                prefix = {
                  font = 2;
                  text = "󰢮";
                };
              };
              label.text = "%output:2%%";
            } cfg.mem-cmd;
          }
        ];
      in
      utils.modulesWithSharedAttrs modules common;
  };
}
