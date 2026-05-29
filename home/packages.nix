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
    yarn
    pinact
    terraform
    ollama
    uv
    claude-code
    firebase-tools
    mise
    graphviz
    ffmpeg
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
