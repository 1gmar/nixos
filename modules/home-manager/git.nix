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
        enable = false;
        enableAsDifftool = true;
      };
      enable = true;
      userEmail = "mr.igor.marta@gmail.com";
      userName = "Igor Marta";
      extraConfig = {
        color.blame.highlightRecent = "#268bd2,12 month ago,#2aa198,6 month ago,#859900,3 month ago,#b58900,1 month ago,#cb4b16,1 week ago,#dc322f";
        credential = {
          helper = "store";
          "https://github.com".username = "1gmar";
        };
        difftool.prompt = false;
        init.defaultBranch = "main";
      };
    };
  };
}
