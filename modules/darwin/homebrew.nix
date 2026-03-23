{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };
    brews = [
      "cocoapods"
    ];
    casks = [
      "alfred"
      "android-studio"
      "bambu-studio"
      "claude"
      "dropbox"
      "font-hack-nerd-font"
      "font-hackgen"
      "gcloud-cli"
      "ghostty"
      "google-chrome"
      "google-japanese-ime"
      "iterm2"
      "notion"
      "obsidian"
      "openscad@snapshot"
      "rancher"
      "skitch"
      "slack"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "xquartz"
      "zoom"
    ];
    masApps = {
      "Keynote" = 409183694;
      "LINE" = 539883307;
      "Numbers" = 409203825;
      "Transporter" = 1450874784;
      "Xcode" = 497799835;
    };
  };
}
