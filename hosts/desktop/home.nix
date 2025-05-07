{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "igmar";
    homeDirectory = "/home/igmar";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = [
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];
    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
      ".config/weathercrab/wthrr.ron" = {
        force = true;
        text = ''
          (
               address: "Chisinau,MD",
               language: "en_US",
               forecast: [],
               units: (
                   temperature: celsius,
                   speed: kmh,
                   time: military,
                   precipitation: probability,
               ),
               gui: (
                   border: rounded,
                   color: default,
                   graph: (
                       style: lines(solid),
                       rowspan: double,
                       time_indicator: true,
                   ),
                   greeting: false,
               ),
          )
        '';
      };
      ".mozilla/firefox/igmar/user.js".text = ''
        user_pref("browser.bookmarks.restore_default_bookmarks", false);
        user_pref("browser.fullscreen.autohide", false);
        user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);
        user_pref("browser.newtabpage.activity-stream.showSearch", false);
        user_pref("browser.newtabpage.activity-stream.showSponsored", false);
        user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
        user_pref("browser.newtabpage.activity-stream.topSitesRows", 2);
        user_pref("browser.newtabpage.pinned", "[{\"baseDomain\":\"twitch.tv\",\"url\":\"https://www.twitch.tv/\"},{\"baseDomain\":\"otpinternetbanking.md\",\"label\":\"OTP Internet Banking\",\"url\":\"https://www.otpinternetbanking.md/\"},{\"baseDomain\":\"translate.google.com\",\"url\":\"https://translate.google.com/\"},{\"baseDomain\":\"myanimelist.net\",\"label\":\"Anime - MyAnimeList.net\",\"url\":\"https://myanimelist.net/anime.php\"},{\"baseDomain\":\"pairdrop.net\",\"label\":\"PairDrop | Transfer Files Cross-Platform. No Setup; No Signup.\",\"url\":\"https://pairdrop.net/\"},{\"baseDomain\":\"evms.md\",\"label\":\"eVMS.md – prima platformă online pentru investiții directe în Valori Mobiliare de Stat\",\"url\":\"https://evms.md/\"},{\"label\":\"Cabinetul Personal\",\"url\":\"https://oficiulonline.premierenergy.md/office/\"},{\"label\":\"Bine ați venit în cabinetul personal al consumatorului SA „Moldovagaz”!\",\"url\":\"https://my.moldovagaz.md/home\"},{\"label\":\"Curs.md - Curs valutar\",\"url\":\"https://www.curs.md/ro\"},{\"label\":\"IBKR\",\"url\":\"https://www.interactivebrokers.co.uk/en/home.php\"},{\"label\":\"MCabinet\",\"url\":\"https://mcabinet.gov.md\"}]");
        user_pref("browser.preferences.defaultPerformanceSettings.enabled", false);
        user_pref("browser.sessionstore.restore_on_demand", true);
        user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);
        user_pref("browser.sessionstore.restore_tabs_lazily", true);
        user_pref("browser.toolbars.bookmarks.visibility", "newtab");
        user_pref("browser.translations.automaticallyPopup", false);
        user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
        user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");
        user_pref("browser.urlbar.suggest.searches", true);
        user_pref("browser.warnOnQuitShortcut", false);
        user_pref("extensions.activeThemeID", "firefox-compact-light@mozilla.org");
        user_pref("media.ffmpeg.vaapi.enabled", true);
        user_pref("middlemouse.paste", false);
        user_pref("privacy.clearOnShutdown.cookies", false);
        user_pref("privacy.clearOnShutdown.history", false);
        user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);
        user_pref("privacy.resistFingerprinting", false);
        user_pref("reader.color_scheme", "sepia");
        user_pref("reader.content_width", 5);
        user_pref("reader.font_size", 8);
        user_pref("sidebar.position_start", false);
        user_pref("sidebar.revamp", true);
        user_pref("sidebar.verticalTabs", true);
        user_pref("webgl.disabled", false);
      '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/root/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  activity-watch.enable = true;
  bash.enable = true;
  dconf-settings.enable = true;
  direnv.enable = true;
  dunst.enable = true;
  firefox.enable = true;
  gammastep.enable = true;
  git.enable = true;
  i3wm.enable = true;
  kitty.enable = true;
  librewolf.enable = true;
  nixvim.enable = true;
  picom.enable = true;
  polybar.enable = true;
  rofi.enable = true;
  screen-locker.enable = false;
  ssh.enable = true;
  thunderbird.enable = true;
  vim.enable = true;
}
