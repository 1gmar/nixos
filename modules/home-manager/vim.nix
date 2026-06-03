{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    vim.enable = lib.mkEnableOption "enable vim module";
  };
  config = lib.mkIf config.vim.enable {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ ale ];
      settings = {
        background = "dark";
        expandtab = true;
        number = true;
        relativenumber = true;
        shiftwidth = 2;
      };
      extraConfig = ''
        set autoindent
        filetype plugin indent on
        execute "set <A-j>=\ej"
        execute "set <A-k>=\ek"
        nnoremap <A-j> :m .+1<CR>==
        nnoremap <A-k> :m .-2<CR>==
        inoremap <A-j> <Esc>:m .+1<CR>==gi
        inoremap <A-k> <Esc>:m .-2<CR>==gi
        vnoremap <A-j> :m '>+1<CR>gv=gv
        vnoremap <A-k> :m '<-2<CR>gv=gv
        let g:ale_fixers = {
        \  'nix': ['${pkgs.nixfmt}/bin/nixfmt'],
        \}
        let g:ale_fix_on_save = 1
      '';
    };
  };
}
