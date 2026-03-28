---
name: add-commit-push
description: 変更を確認し、セキュリティチェックを行った上で add → commit → push する
user_invocable: true
---

# add-commit-push

変更内容を確認し、安全性を検証した上で git add → commit → push を実行する。

## 手順

### 1. 変更内容の確認

- `git status` で変更ファイルを一覧表示する
- `git diff` および `git diff --cached` で差分を確認する
- 変更がない場合はその旨を伝えて終了する

### 2. セキュリティチェック

以下に該当するファイルや内容が含まれていないか確認する。1つでも該当する場合は **コミットせず、ユーザーに警告** する。

- **シークレット・認証情報**: API キー、トークン、パスワード、秘密鍵 (`*.pem`, `*.key`)
- **環境変数ファイル**: `.env`, `.env.*`, `credentials.json`, `secrets.*`
- **個人情報**: メールアドレス（noreply 以外）、アクセストークン、SSH 秘密鍵
- **ハードコードされた機密値**: `password=`, `secret=`, `token=`, `api_key=` などのパターン
- **Claude の設定**: `settings.local.json`（`.gitignore` 済みだが念のため確認）

### 3. コミットメッセージの作成

- 変更内容を分析し、適切な type を選択する: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`
- フォーマット: `<type>: <description>`
- 簡潔で変更の意図が伝わるメッセージにする
- ユーザーにメッセージを提示し、確認を取る

### 4. 実行

確認が取れたら以下を順番に実行する:

```bash
git add <対象ファイル>   # git add -A は使わず、ファイルを明示指定する
git commit -m "<message>"
git push
```

- `git add` は変更ファイルを個別に指定する（`-A` や `.` は使わない）
- push 先のリモートブランチがない場合は `git push -u origin <branch>` を使う

### 5. 結果の報告

- `git log --oneline -1` でコミットを確認する
- push の成功・失敗を報告する
