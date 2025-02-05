{
  lib,
  stylixEnable,
  ...
}: {
  options = {};
  config = lib.mkIf stylixEnable {
    stylix.targets = {
      i3.enable = true;
      kitty.enable = false;
      vim.enable = false;
    };
  };
}
