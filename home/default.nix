{ pkgs, config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
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
    ".zshrc".source                            = link "config/zsh/zshrc";
    ".zsh/30_aliases.zsh".source               = link "config/zsh/30_aliases.zsh";
    ".zsh/50_setopt.zsh".source                = link "config/zsh/50_setopt.zsh";
    ".zsh/70_misc.zsh".source                  = link "config/zsh/70_misc.zsh";
    ".zsh/fzf-sources/ghq-list.zsh".source     = link "config/zsh/fzf-sources/ghq-list.zsh";
    ".zsh/fzf-sources/git.zsh".source          = link "config/zsh/fzf-sources/git.zsh";
    ".fzf.zsh".source                          = link "config/fzf/fzf.zsh";

    # git
    ".gitconfig".source                        = link "config/git/config";
    ".gitattributes".source                    = link "config/git/attributes";
    ".gitignore-global".source                 = link "config/git/ignore";

    # vim
    ".vimrc".source                            = link "config/vim/vimrc";

    # runtime versions
    ".tool-versions".source                    = link "config/mise/tool-versions";

    # claude
    ".claude/commands/create-pr.md".source     = link "config/claude/commands/create-pr.md";
    ".claude/statusline-command.sh".source     = link "config/claude/statusline-command.sh";
  };

  xdg.configFile = {
    "ghostty/config".source = link "config/ghostty/config";
    "gh/config.yml".source  = link "config/gh/config.yml";
  };
}
