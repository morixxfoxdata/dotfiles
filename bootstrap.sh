#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/morixxfoxdata/dotfiles.git"
REPO_SSH="git@github.com:morixxfoxdata/dotfiles.git"

info() { echo "[INFO] $*"; }
error() { echo "[ERROR] $*" >&2; exit 1; }

# OS 検出
detect_os() {
  case "$(uname -s)" in
    Darwin) echo "darwin" ;;
    Linux)  echo "linux" ;;
    *)      error "Unsupported OS: $(uname -s)" ;;
  esac
}

# Nix インストール
install_nix() {
  if command -v nix &>/dev/null; then
    info "Nix is already installed"
    return
  fi
  info "Installing Nix via Determinate Systems installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  # 現在のシェルで Nix を利用可能にする
  if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}

# リポジトリクローン
clone_repo() {
  if [ -d "$DOTFILES_DIR" ]; then
    info "Dotfiles directory already exists: $DOTFILES_DIR"
    return
  fi
  # SSH が使えるなら SSH でクローン
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    info "Cloning via SSH..."
    git clone "$REPO_SSH" "$DOTFILES_DIR"
  else
    info "Cloning via HTTPS..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
  fi
}

# Home Manager の適用
apply_config() {
  local hostname="${1:-$(hostname -s)}"
  info "Applying Home Manager configuration for: $hostname"
  cd "$DOTFILES_DIR"
  nix run home-manager -- switch --flake ".#$hostname"
}

main() {
  local os hostname

  os=$(detect_os)
  info "Detected OS: $os"

  install_nix
  clone_repo

  # ホスト名を引数から取得、なければ対話的に選択
  if [ $# -ge 1 ]; then
    hostname="$1"
  else
    info "Available hosts: NorikinoMacBook-Pro, Mac-mini, gansan"
    printf "Enter hostname (or press Enter for auto-detect): "
    read -r hostname
    hostname="${hostname:-$(hostname -s)}"
  fi

  apply_config "$hostname"
  info "Done! Open a new terminal to use the new configuration."
}

main "$@"
