{ pkgs, ... }: {
  imports = [
    ./packages.nix
  ];

  home.username = "noboruishikura";
  home.homeDirectory = "/Users/noboruishikura";
  home.stateVersion = "24.11";

  home.file = {
    # zsh プラグイン (Nix管理パスを動的生成)
    ".zsh/plugins.zsh".text = ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions
    '';

    # zsh 設定ファイル
    ".zshrc".source                            = ../config/zsh/zshrc;
    ".zsh/30_aliases.zsh".source               = ../config/zsh/30_aliases.zsh;
    ".zsh/50_setopt.zsh".source                = ../config/zsh/50_setopt.zsh;
    ".zsh/70_misc.zsh".source                  = ../config/zsh/70_misc.zsh;
    ".zsh/fzf-sources/ghq-list.zsh".source     = ../config/zsh/fzf-sources/ghq-list.zsh;
    ".zsh/fzf-sources/git.zsh".source          = ../config/zsh/fzf-sources/git.zsh;
    ".fzf.zsh".source                          = ../config/fzf/fzf.zsh;

    # git
    ".gitconfig".source                        = ../config/git/config;
    ".gitattributes".source                    = ../config/git/attributes;
    ".gitignore-global".source                 = ../config/git/ignore;

    # vim
    ".vimrc".source                            = ../config/vim/vimrc;

    # runtime versions
    ".tool-versions".source                    = ../config/mise/tool-versions;

    # claude
    ".claude/commands/create-pr.md".source     = ../config/claude/commands/create-pr.md;
  };

  xdg.configFile = {
    "ghostty/config".source = ../config/ghostty/config;
    "gh/config.yml".source  = ../config/gh/config.yml;
  };
}
