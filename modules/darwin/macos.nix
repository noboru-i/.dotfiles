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
      # キーを長押ししたときにアクセント記号メニューではなくキーリピートを使用
      ApplePressAndHoldEnabled = false;
      # キーボード: ユーザ辞書設定
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      # トラックパッド: スクロールの方向:ナチュラル -> OFF
      "com.apple.swipescrolldirection" = false;
      # トラックパッド: 軌跡の速さ -> 一番速く
      "com.apple.trackpad.scaling" = 3.0;
    };
    trackpad = {
      Clicking = true;
    };
    CustomUserPreferences = {
      "com.apple.dock" = {
        "expose-animation-duration" = 0.1;
      };
      # 一般: Handoff -> OFF
      "com.apple.coreservices.useractivityd" = {
        ActivityAdvertisingAllowed = false;
        ActivityReceivingAllowed = false;
      };
      # 共有: AirPlayレシーバー -> OFF
      "com.apple.controlcenter" = {
        AirplayRecieverEnabled = false;
      };
    };
  };
}
