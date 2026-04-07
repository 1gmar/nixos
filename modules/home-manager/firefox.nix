{ config, lib, ... }:
let
  activity-watch = "{ef87d84c-2127-493f-b952-5b4e744245bc}";
  better-ttv = "firefox@betterttv.net";
  ddg-privacy = "jid1-ZAdIEUB7XOzOJw@jetpack";
  feedbro = "{a9c2ad37-e940-4892-8dce-cd73c6cbbc0c}";
  franker-facez = "frankerfacez@frankerfacez.com";
  keepassxc = "keepassxc-browser@keepassxc.org";
  proton-vpn = "vpn@proton.ch";
  return-youtube-dislike = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
  rikaichamp = "{59812185-ea92-4cca-8ab7-cfcacee81281}";
  stylus = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
  ublock = "uBlock0@raymondhill.net";
  unhook = "myallychou@gmail.com";
  vimium = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
in
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
        DisableRemoteImprovements = true;
        DisableTelemetry = true;
        ExtensionSettings = {
          "*" = {
            allowed_types = [
              "theme"
              "dictionary"
              "locale"
              "sitepermission"
            ];
            default_area = "menupanel";
            installation_mode = "allowed";
            private_browsing = false;
          };
          ${activity-watch} = lib.mkIf config.activity-watch.enable {
            default_area = "navbar";
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${activity-watch}/latest.xpi";
          };
          ${better-ttv} = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${better-ttv}/latest.xpi";
          };
          ${ddg-privacy} = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ddg-privacy}/latest.xpi";
            private_browsing = true;
          };
          ${feedbro} = {
            default_area = "navbar";
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${feedbro}/latest.xpi";
          };
          ${franker-facez} = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${franker-facez}/latest.xpi";
          };
          ${keepassxc} = lib.mkIf config.keepassxc.enable {
            default_area = "navbar";
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${keepassxc}/latest.xpi";
            private_browsing = true;
          };
          ${proton-vpn} = {
            default_area = "navbar";
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${proton-vpn}/latest.xpi";
            private_browsing = true;
          };
          ${return-youtube-dislike} = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${return-youtube-dislike}/latest.xpi";
            private_browsing = true;
          };
          ${rikaichamp} = {
            default_area = "navbar";
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${rikaichamp}/latest.xpi";
            private_browsing = true;
          };
          ${stylus} = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${stylus}/latest.xpi";
            private_browsing = true;
          };
          ${ublock} = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ublock}/latest.xpi";
            private_browsing = true;
          };
          ${unhook} = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${unhook}/latest.xpi";
            private_browsing = true;
          };
          ${vimium} = {
            default_area = "navbar";
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${vimium}/latest.xpi";
            private_browsing = true;
          };
        };
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
          "browser.ai.control.pdfjsAltText" = "blocked";
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
