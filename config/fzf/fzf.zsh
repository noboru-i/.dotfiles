# Setup fzf (Nix-managed)
if command -v fzf &>/dev/null; then
  _fzf_base="${HOME}/.nix-profile/share/fzf"
  [[ $- == *i* ]] && source "${_fzf_base}/completion.zsh" 2>/dev/null
  source "${_fzf_base}/key-bindings.zsh" 2>/dev/null
fi
