{
  lib,
  stylixEnable,
  ...
}: {
  options = {};
  config = lib.mkIf stylixEnable {
    stylix.targets = {
      i3.enable = true;
      kitty.enable = true;
      vim.enable = false;
    };
  };
}
