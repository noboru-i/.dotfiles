# パスの指定
## nodebrew
export PATH=~/.nodebrew/current/bin:$PATH
nodebrew use stable > /dev/null
## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
## pyenv
export PYENV_ROOT=/usr/local/opt/pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
## go
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.go/bin
## その他のコマンド
export PATH=~/bin:$PATH
## Android
export PATH=~/android-sdks/tools:$PATH
export PATH=~/android-sdks/platform-tools:$PATH
JAVA8_HOME=`/usr/libexec/java_home -v "1.8" -F`
if [ $? -eq 0 ]; then
    export JAVA8_HOME
fi

# 色を使用出来るようにする
autoload -Uz colors
colors
# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# diffに色を付ける
export LESS="-R"
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

# alias
alias ls='ls -G'
alias ll='ls -alFG'
alias la='ls -a'
eval "$(hub alias -s)"

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
# hub completions
fpath=(~/.zsh/completions $fpath)
## 補完に関するその他のオプション
setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
# 補完機能を有効にする
autoload -U compinit && compinit -C

# Ctrl+wで"/"までを消す
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

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

# svn
export SVN_EDITOR=vim

# プロンプト
local p_cdir="%B%F{blue}[%~]%f%b"
local p_mark="%B%(!,#,>)%b"
## gitの情報を表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%r)-[%b]'
zstyle ':vcs_info:*' actionformats '(%r)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
local p_vcs="%1(v|%F{green}%1v%f|)"
PROMPT="$p_cdir $p_vcs"$'\n'"$p_mark "

autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 200
export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=5
source ~/.zsh/zsh-notify/notify.plugin.zsh

# peco
for f (~/.zsh/peco-sources/*) source "${f}" # load peco sources
alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}")'
bindkey '^]' peco-src
bindkey '^r' peco-select-history

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# Antigen
if [[ -f $HOME/.zsh/antigen/antigen.zsh ]]; then
    source $HOME/.zsh/antigen/antigen.zsh
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle zsh-users/zsh-completions src
    antigen apply
fi

# docker-machine
if [ "`docker-machine status default`" = "Running" ]; then
   eval "$(docker-machine env default)"
fi
