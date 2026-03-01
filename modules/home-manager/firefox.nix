{
  lib,
  config,
  ...
}:
{
  options.firefox = {
    enable = lib.mkEnableOption "enable firefox module";
  };
  config = lib.mkIf config.firefox.enable {
    home.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      NVD_BACKEND = "direct";
    };
    programs.firefox = {
      enable = true;
      languagePacks = [
        "en-US"
        "ja"
      ];
      policies = {
        DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
        DisableFirefoxAccounts = true;
        DisablePocket = true;
        DisableTelemetry = true;
        GenerativeAI = {
          Enabled = false;
          Chatbot = false;
          LinkPreviews = false;
          TabGroups = false;
          Locked = true;
        };
        PasswordManagerEnabled = false;
        PictureInPicture = {
          Enabled = false;
          Locked = true;
        };
      };
      profiles."${config.home.username}" = {
        isDefault = true;
        settings = {
          "browser.ai.control.default" = "blocked";
          "browser.ai.control.linkPreviewKeyPoints" = "blocked";
          "browser.ai.control.pdfjsAltText" = "blocked";
          "browser.ai.control.sidebarChatbot" = "blocked";
          "browser.ai.control.smartTabGroups" = "blocked";
          "browser.ai.control.translations" = "blocked";
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.fullscreen.autohide" = false;
          "browser.ml.chat.menu" = false;
          "browser.ml.chat.page.footerBadge" = false;
          "browser.ml.chat.page.menuBadge" = false;
          "browser.ml.enable" = false;
          "browser.ml.linkPreview.enabled" = false;
          "browser.ml.pageAssist.enabled" = false;
          "browser.ml.smartAssist.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = true;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.topSitesSows" = 2;
          "browser.newtabpage.pinned" = [
            {
              basedomain = "twitch.tv";
              url = "https://www.twitch.tv/";
            }
            {
              basedomain = "otpinternetbanking.md";
              label = "otp internet banking";
              url = "https://www.otpinternetbanking.md/";
            }
            {
              basedomain = "translate.google.com";
              url = "https://translate.google.com/";
            }
            {
              basedomain = "myanimelist.net";
              label = "anime - myanimelist.net";
              url = "https://myanimelist.net/anime.php";
            }
            {
              basedomain = "pairdrop.net";
              label = "pairdrop";
              url = "http://192.168.100.11:3000/";
            }
            {
              basedomain = "evms.md";
              label = "evms.md – prima platformă online pentru investiții directe în valori mobiliare de stat";
              url = "https://evms.md/";
            }
            {
              label = "Premierenergy";
              url = "https://oficiulonline.premierenergy.md/office/";
            }
            {
              label = "Energocom";
              url = "https://my.energocom.md/home";
            }
            {
              label = "curs.md - curs valutar";
              url = "https://www.curs.md/ro";
            }
            {
              label = "ibkr";
              url = "https://www.interactivebrokers.co.uk/en/home.php";
            }
            {
              label = "mcabinet";
              url = "https://mcabinet.gov.md";
            }
            {
              label = "Fagura";
              url = "https://fagura.com";
            }
          ];
          "browser.preferences.defaultPerformanceSettings.enabled" = false;
          "browser.search.visualSearch.featureGate" = false;
          "browser.sessionstore.restore_on_demand" = true;
          "browser.sessionstore.restore_pinned_tabs_on_demand" = true;
          "browser.sessionstore.restore_tabs_lazily" = true;
          "browser.tabs.groups.smart.enabled" = false;
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.translations.automaticallyPopup" = false;
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.placeholderName.private" = "DuckDuckGo";
          "browser.urlbar.quicksuggest.mlEnabled" = false;
          "browser.urlbar.suggest.searches" = true;
          "browser.warnOnQuitShortcut" = false;
          "extensions.activeThemeId" = "firefox-compact-light@mozilla.org";
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.ml.enabled" = false;
          "gfx.x11-egl.force-enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "middlemouse.paste" = false;
          "pdfjs.enableAltText" = false;
          "places.semanticHistory.featureGate" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "privacy.resistFingerprinting" = false;
          "reader.color_scheme" = "sepia";
          "reader.content_width" = 5;
          "reader.font_size" = 8;
          "reader.text_alignment" = "justify";
          "sidebar.position_start" = false;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "webgl.disabled" = false;
          "widget.dmabuf.force-enabled" = true;
        };
        userChrome = ''
          /*** Hide Tab Close buttons ***/
          .tabbrowser-tab .tab-close-button {
            visibility: collapse !important;
          }
        '';
      };
    };
    xsession.windowManager.i3.config.startup = lib.mkIf config.i3wm.enable [
      {
        always = false;
        command = "${config.home.profileDirectory}/bin/firefox";
        notification = false;
      }
    ];
  };
}
