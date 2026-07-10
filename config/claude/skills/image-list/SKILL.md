---
name: image-list
description: |
  リポジトリ内の全画像ファイルを洗い出し、パス・プレビュー・縦横解像度を一覧表示するHTMLファイル（image-list.html）をプロジェクトルートに生成するスキル。
  「画像一覧を作りたい」「リポジトリの画像ファイルを確認したい」「どんな画像があるか見たい」「image-list を作って」といったリクエストで必ず使用する。
---

# image-list スキル

リポジトリ内の画像ファイルを洗い出し、プレビュー・解像度付きのHTML一覧を生成する。

HTMLのテンプレートは `assets/template.html` に用意してある。
このファイルを読み込んでプレースホルダーを置き換えることで `image-list.html` を生成する。

## 手順

### Step 1: 画像ファイルの収集

`find` コマンドで対象ファイルを列挙する。依存パッケージ・バージョン管理・ビルド成果物・キャッシュに該当するディレクトリは除外する。

代表的な除外対象（リポジトリの構成に応じて適宜追加する）:

| カテゴリ | 除外パターン例 |
|---|---|
| バージョン管理 | `.git` |
| 依存パッケージ | `node_modules`, `vendor`, `.venv`, `venv` |
| ビルド成果物 | `dist`, `build`, `out`, `.next`, `.nuxt`, `target` |
| キャッシュ | `.cache`, `.parcel-cache`, `.turbo`, `__pycache__` |
| テスト出力 | `coverage`, `.nyc_output` |

```bash
find . -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \
  -o -iname "*.gif" -o -iname "*.svg" -o -iname "*.webp" \
  -o -iname "*.ico" -o -iname "*.bmp" \) \
  2>/dev/null \
  | grep -v '/\.git/' \
  | grep -v '/node_modules/' \
  | sort
```

上記は最小構成。上の表を参考に、プロジェクトで該当するカテゴリの `grep -v` を適宜追加する。

結果をプロジェクトルートからの相対パスのリストとして整理する。

### Step 2: テンプレートを読み込んでプレースホルダーを置換

`assets/template.html` を Read し、以下の2箇所を置き換えてプロジェクトルートに `image-list.html` として書き出す。

| プレースホルダー | 置換内容 |
|---|---|
| `__IMAGES_JSON__` | Step 1 で収集した相対パスの JSON 配列（例: `["public/logo.png", "src/assets/icon.svg"]`） |
| `__REPO_NAME__` | カレントディレクトリ名（例: `my-project`） |

置換はテキストの単純な文字列置換でよい。

### Step 3: 完了報告

生成後に以下を伝える：
- 出力先（`image-list.html`）
- 検出した画像の総数と内訳（形式別）
- ブラウザで開く方法（`open image-list.html` または `npx serve .`）

> Chromeで `file://` から開くと画像がCORSでブロックされる場合がある。その際は Firefox か `npx serve .` を案内する。
