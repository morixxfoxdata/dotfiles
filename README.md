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
├── flake.nix              # Nix Flakes エントリポイント
├── flake.lock             # 依存のロックファイル
├── .github/workflows/     # CI (nix flake check)
└── home-manager/
    ├── home.nix           # パッケージ管理・Home Manager 設定
    ├── dotfiles.nix       # link_force によるシンボリックリンク管理
    ├── git/               # Git 設定
    │   ├── .gitconfig
    │   └── ignore
    ├── nvim/              # Neovim (LazyVim)
    │   ├── init.lua
    │   └── lua/
    │       ├── config/    # options, keymaps, autocmds
    │       └── plugins/   # プラグイン設定
    ├── zsh/               # Zsh 設定
    │   ├── .zshrc
    │   └── .zshenv
    ├── starship/          # Starship プロンプト
    │   └── starship.toml
    ├── ghostty/           # Ghostty ターミナル
    │   └── config
    ├── gh/                # GitHub CLI
    │   └── config.yml
    ├── karabiner/         # Karabiner-Elements
    │   └── karabiner.json
    └── aerospace/         # AeroSpace ウィンドウマネージャ
        └── aerospace.toml
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
~/.config/nvim       → ~/dotfiles/home-manager/nvim        (編集可能)
~/.config/ghostty/   → ~/dotfiles/home-manager/ghostty/     (編集可能)
~/.gitconfig         → ~/dotfiles/home-manager/git/.gitconfig
```

設定を変更したらそのまま `git commit` できる。

## 各ツールの設定内容

### Git (`home-manager/git/`)

- ユーザー名: Morixx
- GitHub への接続を SSH に強制 (`url.insteadOf`)
- Git LFS 有効
- `ignore` でグローバルな gitignore を管理

### Neovim (`home-manager/nvim/`)

LazyVim をベースにした設定。

- **プラグイン管理**: lazy.nvim
- **ファイラー**: snacks.nvim (explorer) — 隠しファイル・ignored ファイルも表示
- **LaTeX**: vimtex + Skim でプレビュー
- **Markdown**: `<leader>mp` で Typora プレビュー、`.mdx` を markdown として認識
- **オプション**: スペルチェック言語は en + cjk、conceallevel = 0

プラグインを追加するには `home-manager/nvim/lua/plugins/` に新しい `.lua` ファイルを作成する。

### Zsh (`home-manager/zsh/`)

- `.zshenv` — Cargo の環境変数を読み込み
- `.zshrc` — nvm、Google Cloud SDK、Starship の初期化。`EDITOR=nvim`

### Starship (`home-manager/starship/`)

Nord 系カラーの 2 行プロンプト。

- **左**: ディレクトリ + Git ブランチ・ステータス
- **右**: コマンド実行時間 + ユーザー名 + 時刻
- AWS / GCloud のプロンプト表示は無効化

### Ghostty (`home-manager/ghostty/`)

- テーマ: Kanagawa Wave
- 背景透過: 75%、ブラー半径 20
- タイトルバーのプロキシアイコンを非表示

### Karabiner-Elements (`home-manager/karabiner/`)

- 左 ⌘ 単押し → 英数、右 ⌘ 単押し → かな（US 配列向け IME 切替）
- `international3` → バッククォート（JIS キーボード互換）

### AeroSpace (`home-manager/aerospace/`)

タイル型ウィンドウマネージャ。

- **フォーカス移動**: `alt + h/j/k/l`
- **ウィンドウ移動**: `alt + shift + h/j/k/l`
- **ワークスペース切替**: `alt + 1-9` / `alt + a-z`
- **リサイズ**: `alt + shift + -/=`
- ワークスペース 1〜9 はセカンダリモニタに割当
- サービスモード (`alt + shift + ;`): 設定リロード、レイアウトリセットなど

### GitHub CLI (`home-manager/gh/`)

- エイリアス: `gh co` → `gh pr checkout`

## パッケージを追加するには

新しいツールを dotfiles の管理下に追加する手順:

### 1. パッケージをインストール

`home-manager/home.nix` の `home.packages` にパッケージを追加する。

```nix
home.packages = with pkgs; [
  # ... 既存のパッケージ
  tmux        # ← 追加
];
```

パッケージ名は [Nix Packages Search](https://search.nixos.org/packages) で検索できる。

### 2. 設定ファイルを配置

```bash
mkdir home-manager/tmux
# 設定ファイルを作成
vim home-manager/tmux/tmux.conf
```

### 3. シンボリックリンクを登録

`home-manager/dotfiles.nix` に `link_force` の行を追加する。

```nix
# Tmux
link_force "${dotfilesDir}/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
```

### 4. 適用

```bash
home-manager switch --flake .
```

これでパッケージのインストールとシンボリックリンクの作成が一度に行われる。

> **設定ファイルが不要なツール**（fzf など）は、手順 1 と 4 だけでよい。

## 更新

```bash
# flake.lock を更新（全依存を最新に）
nix flake update

# 適用
home-manager switch --flake .
```

## CI

GitHub Actions (`.github/workflows/check.yml`) により、push / PR 時に以下を自動チェック:

- `nix flake check` — flake の構文検証
- Home Manager 設定の評価（ビルドが通るか確認）
