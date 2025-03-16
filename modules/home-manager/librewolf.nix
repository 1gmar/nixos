{
  lib,
  config,
  ...
}: {
  options = {
    librewolf.enable = lib.mkEnableOption "enable librewolf module";
  };
  config = lib.mkIf config.librewolf.enable {
    programs.librewolf = {
      enable = true;
      languagePacks = ["en-US" "ja"];
      settings = {
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.fullscreen.autohide" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = true;
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 2;
        "browser.preferences.defaultPerformanceSettings.enabled" = false;
        "browser.sessionstore.restore_on_demand" = true;
        "browser.sessionstore.restore_pinned_tabs_on_demand" = true;
        "browser.sessionstore.restore_tabs_lazily" = true;
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "browser.translations.automaticallyPopup" = false;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.urlbar.suggest.searches" = true;
        "browser.warnOnQuitShortcut" = false;
        "extensions.activeThemeID" = "firefox-compact-light@mozilla.org";
        "media.ffmpeg.vaapi.enabled" = true;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "middlemouse.paste" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.resistFingerprinting" = false;
        "reader.color_scheme" = "sepia";
        "reader.content_width" = 5;
        "reader.font_size" = 8;
        "sidebar.position_start" = false;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "webgl.disabled" = false;
      };
    };
  };
}
