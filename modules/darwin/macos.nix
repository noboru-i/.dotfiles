{ ... }: {
  system.defaults = {
    dock = {
      autohide = false; # 自動的に隠さない
      tilesize = 32; # アイコンサイズ
      show-recents = false; # 最近使ったアプリを非表示
      minimize-to-application = true; # アプリアイコンにしまう
      mru-spaces = false; # Spacesの自動並び替えをしない
    };
    finder = {
      AppleShowAllExtensions = true; # 拡張子を表示
      ShowPathbar = true; # パスバーを表示
      ShowStatusBar = true; # ステータスバーを表示
      FXDefaultSearchScope = "SCcf"; # 検索対象: 現在のフォルダ
      FXPreferredViewStyle = "clmv"; # 表示: カラム
    };
    NSGlobalDomain = {
      KeyRepeat = 2; # キーリピート速度
      InitialKeyRepeat = 15; # キーリピート開始までの遅延
      "com.apple.sound.beep.feedback" = 0; # 音量変更時の効果音をOFF
      "com.apple.keyboard.fnState" = true; # Fnキーを標準のファンクションキーとして使用
      # キーを長押ししたときにアクセント記号メニューではなくキーリピートを使用
      ApplePressAndHoldEnabled = false;
      # キーボード: ユーザ辞書設定
      NSAutomaticSpellingCorrectionEnabled = false; # 自動スペル修正をOFF
      NSAutomaticCapitalizationEnabled = false; # 自動大文字化をOFF
      NSAutomaticPeriodSubstitutionEnabled = false; # ピリオド自動変換をOFF
      # トラックパッド: スクロールの方向:ナチュラル -> OFF
      "com.apple.swipescrolldirection" = false;
      # トラックパッド: 軌跡の速さ -> 一番速く
      "com.apple.trackpad.scaling" = 3.0;
    };
    trackpad = {
      Clicking = true; # タップでクリック
    };
    CustomUserPreferences = {
      "com.apple.dock" = {
        "expose-animation-duration" = 0.1; # Exposéアニメーション時間を短縮
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
      # デスクトップをタップしてもウィンドウが避けないようにする
      "com.apple.WindowManager" = {
        EnableStandardClickToShowDesktop = false;
      };
    };
  };
}
