# Rustup/Cargo (managed by Nix, but rustup adds toolchains here)
export PATH="$HOME/.cargo/bin:$PATH"

# Nix profile (must be readable from non-interactive shells too, e.g. `ssh host cmd`)
export PATH="$HOME/.nix-profile/bin:$PATH"

# TeX Live (user-scope install at ~/texlive, packages via tlmgr; gansan only —
# the linux bin dir does not exist on the darwin hosts, so this is a no-op there)
if [ -d "$HOME/texlive/2026/bin/x86_64-linux" ]; then
  export PATH="$HOME/texlive/2026/bin/x86_64-linux:$PATH"
fi
