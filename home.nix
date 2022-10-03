{ config, pkgs, lib, ... }:

{
  # xdg = {
    # enable     = true;
    # configHome = "/home/ak/burke/${relativeXDGConfigPath}";
    # dataHome   = "/home/ak/burke/${relativeXDGDataPath}";
    # cacheHome  = "/home/ak/burke/${relativeXDGCachePath}";
  # };

  programs = {
    home-manager.enable = true;
  };

  # home.file.".iterm2_shell_integration.zsh".source =
  # ./home/.iterm2_shell_integration.zsh;

  # home.file.".config/nvim/backup/.keep".text = "";

  home.file.".config/qtile/config.py".source = ./dotfiles/qtile.py;

  programs = {
    vim = {
      enable = true;
      # extraConfig = builtins.readFile ./home/extraConfig.vim;
      settings = {
        number = true;
      };

      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-ruby
        vim-go
        vim-toml
        rust-vim
        ansible-vim
        Jenkinsfile-vim-syntax

        gruvbox
        vim-gitgutter
        # vim-airline

        vim-surround    # cs"'
        vim-commentary  # gcap
        vim-sneak
        supertab

        nerdtree
        fzf-vim
      ];
    };

    bash = {
      enable   = true;
      shellAliases = {
        l = "ranger --choosedir=/home/ak/.rangerdir; LASTDIR=`cat /home/ak/.rangerdir`; cd \"\${LASTDIR}\"";
        h = "history";
        H = "history | grep";
        r = "ranger";
        hm = "home-manager";
      };
    };

    git = {
      enable    = true;
      userName  = "CptnGreen";
      userEmail = "a.krasnoshchekov1992@gmail.com";
      # extraConfig = {};
    };

  };
}

