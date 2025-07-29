{
  sysConfig,
  inputs,
  userName,
  ...
}: {
  imports = [
    inputs.self.homeManagerModules.default
  ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
    };
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  activity-watch.enable = true;
  bash.enable = true;
  dconf-settings.enable = true;
  direnv.enable = true;
  dunst.enable = true;
  firefox.enable = true;
  flatpak.enable = sysConfig.flatpak.enable;
  foliate.enable = true;
  gammastep.enable = true;
  git.enable = true;
  i3wm.enable = true;
  kitty.enable = true;
  librewolf.enable = false;
  nixvim.enable = true;
  picom.enable = true;
  polybar.enable = true;
  rofi.enable = true;
  ssh.enable = true;
  thunderbird.enable = true;
  translate-selected.enable = true;
  vim.enable = true;
  wthrr.enable = true;
}
