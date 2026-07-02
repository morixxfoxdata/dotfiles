# Rustup/Cargo (managed by Nix, but rustup adds toolchains here)
export PATH="$HOME/.cargo/bin:$PATH"

# Nix profile (must be readable from non-interactive shells too, e.g. `ssh host cmd`)
export PATH="$HOME/.nix-profile/bin:$PATH"
