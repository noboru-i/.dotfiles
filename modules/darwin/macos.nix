{ ... }: {
  system.defaults = {
    dock = {
      autohide = false;
      tilesize = 48;
      show-recents = false;
      minimize-to-application = true;
      mru-spaces = false;
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
      "com.apple.keyboard.fnState" = true;
    };
    trackpad = {
      Clicking = true;
    };
  };
}
