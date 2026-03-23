# dotfiles

Nix Flakes + Home Manager で管理する macOS (aarch64-darwin) 開発環境。

## セットアップ

```bash
# 1. Nix をインストール
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh

# 2. リポジトリをクローン
git clone https://github.com/morixxfoxdata/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. 適用
home-manager switch --flake .
```

## 構成

```
dotfiles/
├── flake.nix              # Nix Flakes 設定
├── flake.lock
└── home-manager/
    ├── home.nix           # パッケージ管理
    ├── dotfiles.nix       # link_force によるシンボリックリンク管理
    ├── git/               # Git 設定
    ├── nvim/              # Neovim (LazyVim)
    ├── starship/          # Starship プロンプト
    ├── zsh/               # Zsh 設定
    ├── gh/                # GitHub CLI
    ├── karabiner/         # Karabiner-Elements
    ├── aerospace/         # AeroSpace (ウィンドウマネージャ)
    └── ghostty/           # Ghostty (ターミナル)
```

## 管理パッケージ

| パッケージ | 用途 |
|-----------|------|
| git | バージョン管理 |
| neovim | エディタ |
| starship | シェルプロンプト |
| fzf | ファジーファインダー |
| lazygit | Git TUI |
| yazi | ファイルマネージャ |
| gh | GitHub CLI |
| uv | Python パッケージマネージャ |
| claude-code | AI コーディングアシスタント |
| codex | AI コーディングアシスタント |

## 設定ファイルの管理方式

`home.activation` の `link_force` で、リポジトリのファイルへ直接シンボリックリンクを作成する。Nix store を経由しないため、設定ファイルは mutable（編集可能）。

```
~/.config/nvim → ~/dotfiles/home-manager/nvim  (編集可能)
```

設定を変更したらそのまま `git commit` できる。

## 更新

```bash
# flake.lock を更新
nix flake update

# 適用
home-manager switch --flake .
```
