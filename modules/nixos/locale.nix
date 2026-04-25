{ config, lib, ... }:
{
  options.locale = {
    enable = lib.mkEnableOption "enable locale module";
  };
  config = lib.mkIf config.locale.enable {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "ja_JP.UTF-8";
        LC_IDENTIFICATION = "ja_JP.UTF-8";
        LC_MEASUREMENT = "ja_JP.UTF-8";
        LC_MONETARY = "ja_JP.UTF-8";
        LC_NAME = "ja_JP.UTF-8";
        LC_NUMERIC = "ja_JP.UTF-8";
        LC_PAPER = "ja_JP.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
      };
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
      ];
    };
    time.timeZone = "Europe/Chisinau";
  };
}
