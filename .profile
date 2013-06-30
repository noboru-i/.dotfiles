
# MacPorts Installer addition on 2012-04-02_at_14:15:12: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/Applications/android-sdk-macosx/tools

alias ls='ls -G'
alias ll='ls -alFG'
alias la='ls -a'

function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend
export HISTFILESIZE=1000

#重複履歴を無視
export HISTCONTROL=ignoredups

source ~/.nvm/nvm.sh
nvm use 0.10 > /dev/null

export PATH=/Users/ishikuranoboru/android-sdks/platform-tools:$PATH
export PATH=~/bin:$PATH

# for less command
export LESS='-R'
export LESSOPEN='| /opt/local/bin/src-hilite-lesspipe.sh %s'

export PATH=/usr/local/gradle/bin:$PATH

