# Configure path
## asdf
. /usr/local/opt/asdf/asdf.sh
## Other commands
export PATH=~/bin:$PATH
export PATH=~/bin/google-cloud-sdk/bin:$PATH
export PATH=~/bin/flutter/bin:$PATH
## Android
export ANDROID_HOME=~/Library/Android/sdk
export PATH=~/Library/Android/sdk/tools:$PATH
export PATH=~/Library/Android/sdk/platform-tools:$PATH
export JAVA_HOME=`/usr/libexec/java_home -v "1.8" -F`

# 色を使用出来るようにする
autoload -Uz colors && colors
# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# diffに色を付ける
export LESS="-R"

# 補完機能を有効にする
autoload -U compinit && compinit -C

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 言語
export LANG=ja_JP.UTF-8

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

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
for f (~/.zsh/fzf-sources/*) source "${f}"

# zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"

zplug "marzocchi/zsh-notify"
export SYS_NOTIFIER=`which terminal-notifier`
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=5

if ! zplug check; then
    zplug install
fi
zplug load

# load
for f in ~/.zsh/[0-9]*.(sh|zsh)
do
    source "$f"
done

