{ pkgs, ... }: {
  home.packages = with pkgs; [
    # VCS
    git
    delta
    gh
    ghq

    # Shell tools
    eza
    bat
    fzf
    jq
    tree
    coreutils
    curl
    gnupg

    # Development
    pinact
    terraform
    ollama
    uv
    claude-code-bin
    firebase-tools
    mise
    graphviz
    terminal-notifier
    qemu
    mas
    openjdk
    gcc
    bundletool
    libpq

    # zsh plugins
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
  ];
}
