{
  lib,
  config,
  ...
}: {
  options.ssh = {
    enable = lib.mkEnableOption "enable ssh module";
  };
  config = lib.mkIf config.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
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
