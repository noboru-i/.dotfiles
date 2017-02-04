## 補完に関するその他のオプション
setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
# cdを入力しなくても移動
setopt auto_cd
# 補完候補を詰めて表示
setopt list_packed

# 重複したコマンド履歴を残さない
setopt hist_ignore_dups
# 履歴を共有する
setopt share_history
