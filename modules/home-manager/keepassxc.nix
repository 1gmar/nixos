{ config, lib, ... }:
{
  options.keepassxc = {
    enable = lib.mkEnableOption "enable keepassxc module";
  };
  config = lib.mkIf config.keepassxc.enable {
    programs.keepassxc = {
      enable = true;
      settings = {
        Browser = {
          Enabled = true;
          UpdateBinaryPath = false;
        };

        GUI = {
          MinimizeOnClose = true;
          MinimizeOnStartup = true;
          MinimizeToTray = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-dark";
        };

        PasswordGenerator.SpecialChars = true;

        Security = {
          ClearClipboard = true;
          ClearClipboardTimeout = 60;
          LockDatabaseIdle = true;
          LockDatabaseIdleSeconds = 1800;
        };

        SSHAgent = {
          Enabled = true;
          UseOpenSSH = true;
        };
      };
    };
    xsession.windowManager.i3.config.startup = lib.mkIf config.i3wm.enable [
      {
        always = false;
        command = "${config.home.profileDirectory}/bin/keepassxc";
        notification = false;
      }
    ];
  };
}
