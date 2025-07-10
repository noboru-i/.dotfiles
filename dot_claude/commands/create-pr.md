---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(gh pr create:*)
description: Create a GitHub PullRequest
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

新しいブランチを作成し、変更をコミットしてプルリクエストを作成する。
