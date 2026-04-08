# Zsh plugins
if [ -f "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Zeno
if [ -f "$HOME/.nix-profile/share/zeno/zeno.zsh" ]; then
  source "$HOME/.nix-profile/share/zeno/zeno.zsh"
  if [[ -n $ZENO_LOADED ]]; then
    bindkey ' '  zeno-auto-snippet
    bindkey '^m' zeno-auto-snippet-and-accept-line
    bindkey '^i' zeno-completion
    bindkey '^r' zeno-history-selection
    bindkey '^x ' zeno-insert-space
    bindkey '^x^m' accept-line
    bindkey '^x^z' zeno-toggle-auto-snippet
  fi
fi

# Starship prompt
eval "$(starship init zsh)"

# Editor
export EDITOR="nvim"

# Nix profile
export PATH="$HOME/.nix-profile/bin:$PATH"

# Zoxide
eval "$(zoxide init zsh)"
