# Setup fzf (Nix-managed)
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
fi
