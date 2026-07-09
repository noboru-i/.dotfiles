---
allowed-tools: Bash(git checkout:*), Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(gh pr create:*)
description: Create a GitHub PullRequest
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`

## Your task

上記の変更内容をもとに、以下を実行する。

1. mainブランチにいる場合は新しいブランチを作成する
2. 適切なメッセージで1つのコミットを作成する
3. ブランチをoriginにpushする
4. `gh pr create` でプルリクエストを作成する
   - `.github/pull_request_template.md` が存在する場合は、そのフォーマットに従ってPR本文を記載する
      - チェックリストは項目を削除せず、該当する項目にのみ `[x]` を付ける
   - テンプレートが存在しない場合は、変更内容を簡潔にまとめた本文を記載する
   - 明確な指示がない場合は、Draft状態で作成する
