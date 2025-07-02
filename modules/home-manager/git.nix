{
  lib,
  config,
  ...
}: {
  options.git = {
    enable = lib.mkEnableOption "enable git module";
  };
  config = lib.mkIf config.git.enable {
    programs.git = {
      difftastic = {
        background = "light";
        color = "auto";
        display = "inline";
        enable = true;
        enableAsDifftool = true;
      };
      enable = true;
      userEmail = "mr.igor.marta@gmail.com";
      userName = "Igor Marta";
      extraConfig = {
        credential = {
          helper = "store";
          "https://github.com".username = "1gmar";
        };
        init.defaultBranch = "main";
      };
    };
  };
}
