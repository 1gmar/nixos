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
        desktop = "age1px45273jdkg8mqee0f7mdr4l3vcp965r8vv72fdk430ej2zw44zs393pzr";
      in
      {
        creation_rules = [
          {
            path_regex = "secrets.yaml$";
            key_groups = [
              {
                age = [
                  desktop
                  igmar
                ];
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
      age = {
        sshKeyPaths = [ "/home/${userName}/.ssh/id_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
      secrets = { };
    };
  };
}
