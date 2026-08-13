# Zsh plugins
if [ -f "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# fzf 
if [ -f "$HOME/.nix-profile/share/fzf/key-bindings.zsh" ]; then
  source "$HOME/.nix-profile/share/fzf/key-bindings.zsh"
fi

# Zeno
# nixpkgs の deno が libsqlite3 を動的リンクするようになり、@db/sqlite が
# dlopen する prebuilt sqlite とシンボル衝突して zeno-server が SIGSEGV する。
# deno がリンクしている sqlite を指定して衝突を回避する。
if command -v deno >/dev/null 2>&1; then
  _deno_sqlite=$(ldd "$(readlink -f "$(command -v deno)")" 2>/dev/null | awk '/libsqlite3/{print $3}')
  [ -n "$_deno_sqlite" ] && export DENO_SQLITE_PATH="$_deno_sqlite"
  unset _deno_sqlite
fi
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

# Zoxide
eval "$(zoxide init zsh)"

# mise
eval "$(mise activate zsh)"
export PATH="$HOME/.local/bin:$PATH"

# npm global (prefix is set in ~/.npmrc)
export PATH="$HOME/.npm-global/bin:$PATH"

# >>> Codex installer >>>
export PATH="/home/komori/.local/bin:$PATH"
# <<< Codex installer <<<

# claude code
export CLAUDE_CODE_DISABLE_AGENT_VIEW=1
