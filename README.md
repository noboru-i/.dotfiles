# my dotfiles

## How to use

### Pre requirement

- macOS
- Xcode
- [Homebrew](https://brew.sh/)

### Setup dotfiles

```sh
curl https://raw.githubusercontent.com/noboru-i/.dotfiles/master/install.sh | sh
```

### Add/Update dotfiles

```sh
# Open by VS Code
code ~/.local/share/chezmoi

# Manage a new file with chezmoi
chezmoi add ~/.bashrc

# Check diff
chezmoi diff

# Apply(Paste) to home directory
chezmoi -v apply
```
