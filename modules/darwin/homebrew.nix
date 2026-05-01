{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };
    taps = [
      "gechr/tap"
    ];
    brews = [
      "cocoapods"
    ];
    casks = [
      "1password"
      "alfred"
      "android-studio"
      "bambu-studio"
      "claude"
      "codex" # CLI は原則 Nix 管理だが、nixpkgs の追従が遅いため例外的に Homebrew cask で管理する。
      "dbeaver-community"
      "discord"
      "dropbox"
      "font-hack-nerd-font"
      "font-hackgen"
      "gcloud-cli"
      "ghostty"
      "google-chrome"
      "google-japanese-ime"
      "imageoptim"
      "notion"
      "obsidian"
      "openscad@snapshot"
      "rancher"
      # "skitch"
      "slack"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "gechr/tap/whichspace"
      "zoom"
    ];
    # masApps は nix-darwin の mas get バグにより無効化中 (mas install が正しいコマンド)
    # 以下は App Store から手動インストール:
    #   Keynote (409183694), LINE (539883307), Numbers (409203825)
    #   Transporter (1450874784), Xcode (497799835)
    masApps = {};
  };
}
