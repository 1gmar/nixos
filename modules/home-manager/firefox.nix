{
  lib,
  config,
  ...
}: {
  options.firefox = {
    enable = lib.mkEnableOption "enable firefox module";
  };
  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      languagePacks = ["en-US" "ja"];
      policies = {
        DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
        DisableFirefoxAccounts = true;
        DisablePocket = true;
        DisableTelemetry = true;
        PasswordManagerEnabled = false;
        PictureInPicture = {
          Enabled = false;
          Locked = true;
        };
      };
      #profiles."igmar" = {
      #  isDefault = true;
      #  search = {
      #    default = "ddg";
      #    privateDefault = "ddg";
      #  };
      #  settings = {
      #    "browser.bookmarks.restore_default_bookmarks" = false;
      #    "browser.fullscreen.autohide" = false;
      #    "browser.newtabpage.activity-stream.feeds.topsites" = true;
      #    "browser.newtabpage.activity-stream.showSearch" = false;
      #    "browser.newtabpage.activity-stream.showSponsored" = false;
      #    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      #    "browser.newtabpage.activity-stream.topSitesRows" = 2;
      #    "browser.newtabpage.pinned" = [
      #      {
      #        url = "https://www.twitch.tv/";
      #        baseDomain = "twitch.tv";
      #      }
      #      {
      #        url = "https://www.otpinternetbanking.md/";
      #        label = "OTP Internet Banking";
      #        baseDomain = "otpinternetbanking.md";
      #      }
      #      {
      #        url = "https://translate.google.com/";
      #        baseDomain = "translate.google.com";
      #      }
      #      {
      #        url = "https://myanimelist.net/anime.php";
      #        label = "Anime - MyAnimeList.net";
      #        baseDomain = "myanimelist.net";
      #      }
      #      {
      #        url = "https://pairdrop.net/";
      #        label = "PairDrop | Transfer Files Cross-Platform. No Setup; No Signup.";
      #        baseDomain = "pairdrop.net";
      #      }
      #      {
      #        url = "https://evms.md/";
      #        label = "eVMS.md – prima platformă online pentru investiții directe în Valori Mobiliare de Stat";
      #        baseDomain = "evms.md";
      #      }
      #      {
      #        url = "https://oficiulonline.premierenergy.md/office/";
      #        label = "Cabinetul Personal";
      #      }
      #      {
      #        url = "https://my.moldovagaz.md/home";
      #        label = "Bine ați venit în cabinetul personal al consumatorului SA „Moldovagaz”!";
      #      }
      #      {
      #        url = "https://www.curs.md/ro";
      #        label = "Curs.md - Curs valutar";
      #      }
      #    ];
      #    "browser.preferences.defaultPerformanceSettings.enabled" = false;
      #    "browser.sessionstore.restore_on_demand" = true;
      #    "browser.sessionstore.restore_pinned_tabs_on_demand" = true;
      #    "browser.sessionstore.restore_tabs_lazily" = true;
      #    "browser.toolbars.bookmarks.visibility" = "newtab";
      #    "browser.translations.automaticallyPopup" = false;
      #    "browser.urlbar.placeholderName" = "DuckDuckGo";
      #    "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      #    "browser.urlbar.suggest.searches" = true;
      #    "browser.warnOnQuitShortcut" = false;
      #    "extensions.activeThemeID" = "firefox-compact-light@mozilla.org";
      #    "middlemouse.paste" = false;
      #    "privacy.clearOnShutdown.cookies" = false;
      #    "privacy.clearOnShutdown.history" = false;
      #    "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      #    "privacy.resistFingerprinting" = false;
      #    "reader.color_scheme" = "sepia";
      #    "reader.content_width" = 5;
      #    "reader.font_size" = 8;
      #    "sidebar.main.tools" = "history";
      #    "sidebar.position_start" = false;
      #    "sidebar.revamp" = true;
      #    "sidebar.verticalTabs" = true;
      #    "webgl.disabled" = false;
      #  };
      #};
    };
  };
}
