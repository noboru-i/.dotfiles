## システム環境設定

### 一般

- アプリケーションを終了するときにウインドウを閉じる -> OFF
- このMacとiCloudデバイス間でHandoffを許可 -> OFF

### Dockとメニューバー

- Bluetooth -> メニューバーに表示 -> ON

### Mission Control

- 最新の使用状況に基づいて操作スペースを自動的に並べ替える -> OFF

### アクセシビリティ

- ズーム機能 -> 詳細ボタン -> 最大ズーム -> 2ぐらい

### キーボード

- キーのリピート -> 一番速くする
- リピート入力認識までの時間 -> 一番短く
- ユーザ辞書 に 「めるあど」で自分のメールアドレスを登録
- ユーザ辞書 -> 英字入力中にスペルを自動変換 -> OFF
- ユーザ辞書 -> 文頭を自動的に大文字にする -> OFF
- ユーザ辞書 -> スペースバーを2回押してピリオドを入力 -> OFF
- ショートカット -> 入力ソース -> 両方をOFFに
- ショートカット -> アクセシビリティ -> ズーム機能 -> ON
- 入力ソース -> + -> ひらがな (Google)
- 入力ソース -> 日本語 - ローマ字入力 -> - （削除）

### トラックパッド

- 調べる＆データ検出 -> 3本指でタップ
- タップでクリック -> ON
- 軌跡の速さ -> 一番速く
- スクロールの方向:ナチュラル -> OFF
- その他のジェスチャ -> アプリケーションExpose -> ON

### 共有

- AirPlayレシーバー -> OFF (5000番ポートの利用を停止)

## GitHubの設定

https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
ssh key の生成、それをGitHubに登録

## Xcode をインストール

App Store から Xcode インストール

ターミナルにて、以下を実行
`xcode-select --install`

## Homebrew のインストール

https://brew.sh/index_ja.html に記載のあるインストールスクリプトを実行。

## dotfile を適用

[README.mdを参照](../README.md)

## その他アプリの設定

### Alfred

- General -> Alfred Hotkey -> ^ + Space
- Features -> Clipboard History ->
    - Clipboard History -> Keep Plain Text -> On and 3 Months
    - Viewer Hotkey -> Shift + Command + V

### 1Password

- 環境設定 -> 一般 -> 1Password mini を常に実行し続ける -> ON
- 環境設定 -> 一般 -> リッチアイコンを使用 -> ON
- 環境設定 -> セキュリティ -> Touch IDで1Passwordをロック解除することを許可
- 環境設定 -> セキュリティ -> マスターパスワードを次の期間ごとに要求 -> 最大（2 weeks）

### iTerm2

- Preferences -> Profiles -> Colors -> Color Presets -> Light Background
- Preferences -> Profiles -> Text -> Font -> Ricty Diminished

### GitHub

`gh auth login` を実行する

### Visual Studio Code

- Preferences: Color Theme -> Light (Visual Studio)

### Android Studio

Android SDK や Platform tools をインストール

### Cocoapods

**For M1 Mac**

```
arch -x86_64 sudo gem install ffi
sudo gem install cocoapods
```

↓

```
brew install cocoapods
```
