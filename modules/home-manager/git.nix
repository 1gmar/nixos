{
  colors,
  config,
  lib,
  ...
}:
{
  options.git = {
    enable = lib.mkEnableOption "enable git module";
  };
  config = lib.mkIf config.git.enable {
    nixvim.extensions.mini-git.enableExtDiff = true;
    programs = {
      difftastic = {
        enable = true;
        git = {
          enable = true;
          diffToolMode = true;
        };
        options = {
          background = "light";
          color = "always";
          display = "side-by-side";
          tab-width = 2;
        };
      };
      git = {
        enable = true;
        settings = with colors; {
          color.blame.highlightRecent = "${blue},12 month ago,${cyan},6 month ago,${green},3 month ago,${yellow},1 month ago,${orange},1 week ago,${red}";
          difftool.prompt = false;
          init.defaultBranch = "main";
          pager.difftool = true;
          user = {
            email = "mr.igor.marta@gmail.com";
            name = "Igor Marta";
          };
        };
      };
    };
  };
}
