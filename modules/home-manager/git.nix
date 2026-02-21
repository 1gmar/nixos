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
    programs = {
      difftastic.enable = true;
      git = {
        enable = true;
        settings = with colors; {
          color.blame.highlightRecent = "${blue},12 month ago,${cyan},6 month ago,${green},3 month ago,${yellow},1 month ago,${orange},1 week ago,${red}";
          credential = {
            helper = "store";
            "https://github.com".username = "1gmar";
          };
          diff.tool = "difftastic";
          difftool = {
            difftastic.cmd = "difft --background light --color always --display side-by-side --tab-width 2 $MERGED $LOCAL abcdef1 644 $REMOTE abcdef2 644";
            prompt = false;
          };
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
