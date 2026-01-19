function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --theme=TwoDark --color=always --style=numbers --line-range=:500 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf
