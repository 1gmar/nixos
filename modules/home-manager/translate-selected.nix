{
  config,
  lib,
  pkgs,
  ...
}: {
  options.translate-selected = {
    enable = lib.mkEnableOption "enable translate-selected module";
  };
  config = lib.mkIf (config.translate-selected.enable
    && config.xsession.windowManager.i3.enable
    && config.programs.rofi.enable) {
    home.packages = with pkgs; [translate-shell xclip];
    xsession.windowManager.i3.config.keybindings = let
      escQts = str: "\\\\\"${str}\\\\\"";
      transCmd = langs: "${config.home.profileDirectory}/bin/trans -no-ansi -show-alternatives n -show-languages n -show-prompt-message n -e g ${langs}";
      pipeSelToTrans = langs: "${config.home.profileDirectory}/bin/xclip -o | ${transCmd langs}";
      translateCmd = langs: "${config.home.profileDirectory}/bin/rofi -e ${escQts "$(${pipeSelToTrans langs})"} -theme-str ${escQts "window {width: 22em; height: 10em;}"} -font ${escQts "Fira Sans 18"}";
    in {
      "Control+Mod1+e" = "exec \"${translateCmd ":en"}\"";
      "Control+Mod1+j" = "exec \"${translateCmd "ja:en"}\"";
    };
  };
}
