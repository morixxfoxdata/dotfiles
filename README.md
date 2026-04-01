# dotfiles

Nix Flakes + Home Manager で管理する開発環境。macOS (aarch64-darwin) と Linux (x86_64-linux) に対応。

## クイックスタート

```bash
# ワンコマンドでセットアップ (Nix インストール → クローン → 適用)
# ホスト名は自動検出される (hostname -s の結果が flake.nix のキーと一致する必要あり)
curl -sL https://raw.githubusercontent.com/morixxfoxdata/dotfiles/main/bootstrap.sh | bash
```

### 手動セットアップ

```bash
# 1. Nix をインストール
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh

# 2. リポジトリをクローン
git clone https://github.com/morixxfoxdata/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. 適用 (ホスト名は hostname -s の出力と一致させる)
home-manager switch --flake .#NorikinoMacBook-Pro  # MacBook Pro
home-manager switch --flake .#Mac-mini             # Mac Mini
home-manager switch --flake .#gpu-server           # GPU サーバー
```

## ホスト構成

| ホスト名 | system | 用途 |
|----------|--------|------|
| `NorikinoMacBook-Pro` | aarch64-darwin | MacBook Pro (メイン) |
| `Mac-mini` | aarch64-darwin | Mac Mini |
| `gpu-server` | x86_64-linux | GPU サーバー |

新しいマシンを追加するには `hosts/<name>.nix` を作成し、`flake.nix` の `hosts` に追加する。

## 新しいマシンのセットアップ

別のマシン（Mac Mini など）で環境を構築する手順。

### 1. bootstrap.sh でセットアップ

```bash
# ホスト名が flake.nix に登録済みならワンコマンドで完了
curl -sL https://raw.githubusercontent.com/morixxfoxdata/dotfiles/main/bootstrap.sh | bash
```

bootstrap.sh は以下を自動で行う:
1. Nix をインストール (Determinate Systems installer)
2. リポジトリを `~/dotfiles` にクローン
3. `hostname -s` でホスト名を自動検出し、Home Manager を適用

### 2. SSH 鍵の設定

Git の署名と GitHub 認証に SSH 鍵が必要。

```bash
# Ed25519 鍵を生成
ssh-keygen -t ed25519 -C "your-email@example.com"

# 公開鍵を GitHub に登録 (Authentication key + Signing key の両方)
cat ~/.ssh/id_ed25519.pub
# → https://github.com/settings/keys に追加
```

### 3. リモートを SSH に切り替え

bootstrap.sh は SSH 接続できない場合 HTTPS でクローンする。SSH 鍵を設定した後、リモートを切り替える。

```bash
cd ~/dotfiles
git remote set-url origin git@github.com:morixxfoxdata/dotfiles.git
```

### 4. 動作確認

```bash
# 新しいターミナルを開いて確認
which nvim       # Neovim
which starship   # Starship プロンプト
git config user.name  # Git ユーザー名
```

## 構成

```
dotfiles/
├── flake.nix              # Nix Flakes エントリポイント
├── flake.lock             # 依存のロックファイル
├── bootstrap.sh           # ワンコマンドセットアップスクリプト
├── hosts/                 # ホスト固有の設定
│   ├── default.nix        # hostSpec オプション定義
│   ├── mbp.nix            # MacBook Pro
│   ├── mac-mini.nix       # Mac Mini
│   └── gpu-server.nix     # GPU サーバー
├── .github/workflows/     # CI (nix flake check)
└── home-manager/
    ├── home.nix           # パッケージ管理・Home Manager 設定
    ├── dotfiles.nix       # シンボリックリンク管理 (macOS/Linux 条件分岐)
    ├── git/               # Git 設定
    ├── nvim/              # Neovim (LazyVim)
    ├── zsh/               # Zsh 設定
    ├── starship/          # Starship プロンプト
    ├── ghostty/           # Ghostty ターミナル (macOS)
    ├── gh/                # GitHub CLI
    ├── karabiner/         # Karabiner-Elements (macOS)
    ├── aerospace/         # AeroSpace ウィンドウマネージャ (macOS)
    └── claude/            # Claude Code AI アシスタント設定
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
| nodejs | JavaScript ランタイム |
| google-cloud-sdk | GCP CLI |
| rustup | Rust ツールチェーン |
| zsh-autosuggestions | Zsh 入力補完 |
| zsh-syntax-highlighting | Zsh シンタックスハイライト |
| claude-code | AI コーディングアシスタント |
| codex | AI コーディングアシスタント |

## Flake Apps

```bash
# 設定を適用 (hostname -s でホスト名を自動検出)
nix run .#switch

# flake.lock を更新して適用
nix run .#update
```

## 設定ファイルの管理方式

`home.activation` の `link_force` で、リポジトリのファイルへ直接シンボリックリンクを作成する。Nix store を経由しないため、設定ファイルは mutable（編集可能）。

macOS 専用ツール (Karabiner, AeroSpace, Ghostty) は `hostSpec.isDarwin` による条件分岐で macOS でのみリンクされる。

```
~/.config/nvim       → ~/dotfiles/home-manager/nvim        (編集可能)
~/.config/ghostty/   → ~/dotfiles/home-manager/ghostty/     (macOS only)
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

- **プラグイン**: zsh-autosuggestions, zsh-syntax-highlighting (Nix 管理)
- **プロンプト**: Starship
- **環境変数**: `EDITOR=nvim`
- **Rust**: `$HOME/.cargo/bin` を PATH に追加

### Starship (`home-manager/starship/`)

Nord 系カラーの 2 行プロンプト。

- **左**: ディレクトリ + Git ブランチ・ステータス
- **右**: コマンド実行時間 + ユーザー名 + 時刻
- AWS / GCloud のプロンプト表示は無効化

### Ghostty (`home-manager/ghostty/`) — macOS only

- テーマ: Kanagawa Wave
- 背景透過: 75%、ブラー半径 20
- タイトルバーのプロキシアイコンを非表示

### Karabiner-Elements (`home-manager/karabiner/`) — macOS only

- 左 ⌘ 単押し → 英数、右 ⌘ 単押し → かな（US 配列向け IME 切替）
- `international3` → バッククォート（JIS キーボード互換）

### AeroSpace (`home-manager/aerospace/`) — macOS only

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

macOS 専用のツールは `${lib.optionalString isDarwin '' ... ''}` ブロック内に追加する。

### 4. 適用

```bash
nix run .#switch
```

> **設定ファイルが不要なツール**（fzf など）は、手順 1 と 4 だけでよい。

## ホストを追加するには

新しいマシンを dotfiles の管理下に追加する手順:

### 1. ホスト名を確認

```bash
hostname -s
# 例: My-MacBook, gpu-server-2 など
```

### 2. ホスト設定ファイルを作成

```bash
# hosts/<name>.nix を作成 (例: hosts/my-macbook.nix)
```

```nix
{ ... }:

{
  hostSpec = {
    hostName = "my-macbook";
    username = "yourname";
    homeDirectory = "/Users/yourname";   # Linux なら /home/yourname
    system = "aarch64-darwin";           # Linux なら x86_64-linux
    isDarwin = true;                     # Linux なら false
  };
}
```

### 3. flake.nix に追加

`flake.nix` の `hosts` マップに、`hostname -s` の出力をキーとしてエントリを追加する。

```nix
hosts = {
  # ... 既存エントリ
  My-MacBook = {           # ← hostname -s の出力と一致させる
    system = "aarch64-darwin";
    hostModule = ./hosts/my-macbook.nix;
  };
};
```

### 4. 適用

```bash
nix run .#switch
```

## 更新

```bash
# flake.lock を更新して適用
nix run .#update

# または個別に
nix flake update
nix run .#switch
```

## CI

GitHub Actions (`.github/workflows/check.yml`) により、push / PR 時に以下を自動チェック:

- `nix flake check` — flake の構文検証
- Home Manager 設定の評価（ビルドが通るか確認）
