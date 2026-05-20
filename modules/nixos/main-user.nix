{ lib, config, ... }:
let
  cfg = config.main-user;
  sopsOn = config.sops.enable;
in
{
  options.main-user = with lib.types; {
    enable = lib.mkEnableOption "enable main user module";
    userName = lib.mkOption {
      type = passwdEntry str;
      default = "mainuser";
      description = "username";
    };
    description = lib.mkOption {
      type = passwdEntry str;
      default = "mainuser";
      description = "user description";
    };
    sshPubKeys = lib.mkOption {
      type = listOf singleLineStr;
      default = [ ];
      description = "A list of verbatim OpenSSH public keys that should be added to the user's authorized keys.";
    };
    sops-pass-key = lib.mkOption {
      type = str;
      description = "Sops reference to the user password stored in the sops managed secrets.yaml";
    };
  };
  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops-pass-key}.neededForUsers = lib.mkIf sopsOn true;
    users = {
      mutableUsers = lib.mkIf sopsOn false;
      users.${cfg.userName} = {
        inherit (cfg) description;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
        hashedPasswordFile = lib.mkIf sopsOn config.sops.secrets.${cfg.sops-pass-key}.path;
        isNormalUser = true;
        openssh.authorizedKeys.keys = cfg.sshPubKeys;
        packages = [ ];
      };
    };
  };
}
