# パスの指定
## android
export PATH=/Users/ishikuranoboru/android-sdks/platform-tools:$PATH
## nodebrew
## curl -L git.io/nodebrew | perl - setup
export PATH=$HOME/.nodebrew/current/bin:$PATH
nodebrew use stable > /dev/null
## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
## その他のコマンド
export PATH=~/bin:$PATH

# 色を使用出来るようにする
autoload -Uz colors
colors
# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# alias
alias ls='ls -G'
alias ll='ls -alFG'
alias la='ls -a'

# 補完機能を有効にする
autoload -Uz compinit
compinit
## 補完候補に色を付ける
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''
# zsh-completions
fpath=(~/.dotfiles/zsh-completions/src $fpath)
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

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history    # share command history data

# 言語
export LANG=ja_JP.UTF-8

# プロンプト
local p_cdir="%B%F{blue}[%~]%f%b"
local p_info="%n@%m"
local p_mark="%B%(!,#,>)%b"
PROMPT=" $p_cdir"$'\n'"$p_info $p_mark "
## gitの情報を表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%r)-[%b]'
zstyle ':vcs_info:*' actionformats '(%r)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"

autoload -Uz add-zsh-hook
export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10
source ~/.zsh.d/zsh-notify/notify.plugin.zsh

