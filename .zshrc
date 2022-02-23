# Configure path
if [ -e /opt/homebrew/bin/brew ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi
## asdf
. $(brew --prefix asdf)/asdf.sh
## Flutter
export PATH=$PATH:~/bin/flutter/bin
## Dart tool
export PATH=$PATH:$HOME/.pub-cache/bin
## Android
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:~/Library/Android/sdk/tools
export PATH=$PATH:~/Library/Android/sdk/platform-tools
export JAVA_HOME=`/usr/libexec/java_home -v "1.8" -F`
## gcloud
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
## Monarch
export PATH=$PATH:$HOME/bin/monarch/bin

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
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse'

# zplug
export ZPLUG_HOME=$(brew --prefix zplug)
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "marzocchi/zsh-notify"

if ! zplug check; then
    zplug install
fi
zplug load

## config for zsh-notify
zstyle ':notify:*' error-title "❗️ Failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "🎉 Succeeded (in #{time_elapsed} seconds)"
zstyle ':notify:*' error-sound "Glass"
zstyle ':notify:*' success-sound "default"
zstyle ':notify:*' command-complete-timeout 5
zstyle ':notify:*' always-check-active-window yes

# load
for f in ~/.zsh/[0-9]*.(sh|zsh)
do
    source "$f"
done

