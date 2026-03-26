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
      "1password"
      "alfred"
      "android-studio"
      "bambu-studio"
      "claude"
      "discord"
      "dropbox"
      "font-hack-nerd-font"
      "font-hackgen"
      "gcloud-cli"
      "ghostty"
      "google-chrome"
      "google-japanese-ime"
      "notion"
      "obsidian"
      "openscad@snapshot"
      "rancher"
      "slack"
      "visual-studio-code"
      "visual-studio-code@insiders"
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
