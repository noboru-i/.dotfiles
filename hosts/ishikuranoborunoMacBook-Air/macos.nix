{ ... }: {
  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 48;
      show-recents = false;
      minimize-to-application = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "Nlsv";
    };
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      "com.apple.sound.beep.feedback" = 0;
    };
    trackpad = {
      Clicking = true;
    };
  };
}
