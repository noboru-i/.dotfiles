alias ls='ls -G'
alias ll='ls -alFG'
alias la='ls -a'

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

eval "$(hub alias -s)"
