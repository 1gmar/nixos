{
  lib,
  config,
  ...
}: let
  cfg = config.main-user;
in {
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
      default = [];
      description = "A list of verbatim OpenSSH public keys that should be added to the user's authorized keys.";
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      inherit (cfg) description;
      extraGroups = ["wheel" "networkmanager" "docker"];
      isNormalUser = true;
      openssh.authorizedKeys.keys = cfg.sshPubKeys;
      packages = [];
    };
  };
}
