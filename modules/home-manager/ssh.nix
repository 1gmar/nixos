{
  lib,
  config,
  ...
}: {
  options = {
    ssh.enable = lib.mkEnableOption "enable ssh module";
  };
  config = lib.mkIf config.ssh.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "Git" = {
          host = "github.com";
          identitiesOnly = true;
          identityFile = [
            "~/.ssh/id_github"
          ];
        };
      };
    };
  };
}
