{
  config,
  inputs,
  lib,
  pkgs,
  userName,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  options.sops = {
    enable = lib.mkEnableOption "enable sops module";
  };
  config = lib.mkIf config.sops.enable {
    home-manager.users.${userName}.home.file.".sops.yaml".source = pkgs.writers.writeYAML "sops.yaml" (
      let
        igmar = "age1gtxzasru9qfulgd6q8m09kazzx22gasr4vt9j5v586sa2udpcgrq6qgdnr";
      in
      {
        creation_rules = [
          {
            path_regex = "secrets.yaml$";
            key_groups = [
              {
                age = [ igmar ];
              }
            ];
          }
        ];
        stores.yaml.indent = 2;
      }
    );
    sops = {
      defaultSopsFile = ./secrets.yaml;
      validateSopsFiles = false;
      age.keyFile = "${config.home-manager.users.${userName}.xdg.configHome}/sops/age/keys.txt";
      secrets = { };
    };
  };
}
