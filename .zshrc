# パスの指定
# MacPorts Installer addition on 2012-04-02_at_14:15:12: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
## android
export PATH=/Users/ishikuranoboru/android-sdks/platform-tools:$PATH
## nvm
source ~/.nvm/nvm.sh
nvm use 0.10 > /dev/null
#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
#その他のコマンド
export PATH=~/bin:$PATH

# lessに色をつける
export LESS='-R'
export LESSOPEN='| /opt/local/bin/src-hilite-lesspipe.sh %s'

# 色を使用出来るようにする
autoload -Uz colors
colors

# alias
alias ls='ls -G'
alias ll='ls -alFG'
alias la='ls -a'

# 補完機能を有効にする
autoload -Uz compinit
compinit
## 補完候補に色を付ける
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

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

# vim 風キーバインドにする
# bindkey -v

# 言語
export LANG=ja_JP.UTF-8
# export LANG=C

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


