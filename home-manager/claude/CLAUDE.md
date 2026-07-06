# User Memory (~/.claude/CLAUDE.md)

このファイルは全プロジェクト共通で読み込まれる。プロジェクト固有の情報(ビルドコマンドや規約)は書かず、「自分がどういう人間で、何を毎回説明せずに済ませたいか」だけを書く。

## 専門領域(説明不要・省略してよい)

- 深層学習によるcompressed sensing再構成(GIDC, FCModel, UnrollingCNN)
- 圧縮センシング理論(RIP, ISTA/ADMM, TV最小化)
- Ghost imaging物理(speckleパターン, multimode fiber, WDM-GI)
- PyTorch, W&B, DVCを用いた実験管理・データバージョニング
- Nix / Home Manager / nix-darwin によるdotfiles管理
- Neovim(LazyVim), Ghostty, Zellij での開発ワークフロー
- Claude Code の基本的な使い方(hooks, subagent, CLAUDE.md階層など)

→ これらの分野では、基礎概念の再解説は不要。差分・結論・トレードオフだけ簡潔に。

## 説明を厚めにしてほしい領域

<!-- 例: インフラ未経験、特定言語のイディオムに不慣れ、など。具体的に書くほど機能する -->
- システム開発周りの専門用語
- データベース周りの用語
- ネットワーク周りの用語
- AWS周りの用語

## コミュニケーション・説明スタイル
- 日本語で応対してほしい(技術用語は英語のままでよい)

## よく使うツール・環境

- OS/端末: macOS (MacBook M4 Pro, Mac mini M2), Ghostty
- エディタ: Neovim (LazyVim)
- dotfiles: Nix + Home Manager
- 言語/フレームワーク: Python (PyTorch), TypeScript/React (Vite, Firebase)

## 避けてほしいこと

<!-- 例: 過度に丁寧な前置き、確認を挟みすぎる、など -->
- 抽象的な説明
- 具体的なデータを用いないアバウトな説明
- 判断の原因を省略すること
- 造語やカタカナ造語、省略語を多用すること
