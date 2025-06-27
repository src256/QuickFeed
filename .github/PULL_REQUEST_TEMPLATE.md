## 概要 / Summary

<!-- このPRで何を実装・修正したのか、箇条書きで簡潔に記述してください -->
- Fix: ○○機能のバグ修正
- Add: △△ページのレイアウト追加
- Update: APIレスポンスの型変更

## Issueリンク / Related Issue

<!-- 関連するIssueがあれば貼ってください -->
Fixes #123
Refs #456

## チェックリスト / Checklist

- [ ] 動作確認済み（ローカル or Staging）
- [ ] テストケースを追加・更新した
- [ ] ドキュメントを更新した（必要があれば）
- [ ] AI（Claude等）により生成されたコードの動作確認を行った

## コメント / Notes

<!-- 特に見てほしい点や、補足があれば -->
- Claude Codeにより `src/components/UserCard.tsx` を生成（Promptは `.claude/commands/xxx.md` を使用）
- レイアウト調整は手動で微修正
- APIレスポンスの型を `Partial<User>` → `UserSummary` に変更

## スクリーンショット / Screenshot (任意)

| Before | After |
|--------|-------|
| 画像   | 画像  |
