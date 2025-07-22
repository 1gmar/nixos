{
  colors,
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
        display = "side-by-side";
        enable = false;
        enableAsDifftool = true;
      };
      enable = true;
      userEmail = "mr.igor.marta@gmail.com";
      userName = "Igor Marta";
      extraConfig = with colors; {
        color.blame.highlightRecent = "${blue},12 month ago,${cyan},6 month ago,${green},3 month ago,${yellow},1 month ago,${orange},1 week ago,${red}";
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
