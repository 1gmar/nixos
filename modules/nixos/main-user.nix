{
  lib,
  config,
  ...
}: let
  cfg = config.main-user;
in {
  options.main-user = {
    enable = lib.mkEnableOption "enable main user module";
    userName = lib.mkOption {
      default = "mainuser";
      description = "username";
    };
    description = lib.mkOption {
      default = "mainuser";
      description = "user description";
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      description = "${cfg.description}";
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
      packages = [];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkwcBshP3wZT76G+VFX8SodQx1cxtYqIe+jfM7/DTgz8s9xOZD8stzu/codJsm1/3YSsxt9cafacFVbm229S31JYbjpjpzOFV/ffi26JWmN2300QZxKgHgSWgNxIB01XRYWpnXJ69DDDLorzgkJ10EDQ/7uswV6xIk8VhhUnCE6lDEnsXsJ2oEVbVp+J0ZLk51jUGfhOWkrDXRIhlZvDMH/iLm9I6qLdibVxJqlVSXlGaeQLq0c54gWvKjcBAqnfsjsD9quWNCXXFAy44DRl10rgzpjZtvh9C9jedXmdHOwN5S5D7ULKTWoidGg2GkgLc2vvSsFsTwwl6Nuw/pAruzbEulcW9y8VxeEqY4rBufgD9buF1WCbRPDhhEpyqtL6MHs981zoQUgGTCIMyBSNaWFEl5sjtwfDKr0JAQtkSNCkrANEe0Qzzjybh9nLg9zfdRX4vBexFAOR2i1goSw2OJWFIQfKNYmIqiDXr4UGQhG6sryngZ8jL+UT14RBOKpMs= igmar@pop-os"
      ];
    };
  };
}
