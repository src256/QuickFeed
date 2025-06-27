# CLAUDE.md

- This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
- 必ず日本語で回答してください


- このアプリはmacOS専用であり、iOSには対応不要です
- App Sandboxや権限設定は考慮不要です（開発中の想定）

## アプリ概要
- QuickFeedはmacOS用のSwiftUIアプリケーションです。
- SwiftUIを使ってメニュー常駐型RSSリーダーアプリを作成してください。
- 以下の仕様に沿って実装してください。


## アプリ仕様


###  基本機能

- `MenuBarExtra` を使用して、ステータスバーに常駐するアプリとする
- RSSフィード(例: https://softantenna.com/folders/feed.rss ) を定期的に取得する
- フィードのタイトルをメニューバーアイコンのドロップダウンに一覧表示する
- 各タイトルをクリックすると、既定のブラウザでその記事のURLを開く
- フィードの取得はアプリ起動時と、10分おきに自動更新される


### データ構造

- `RSSItem` 構造体を用意し、以下のプロパティを持つ:
  - `title: String`
  - `link: String`
  - `pubDate: Date?`（オプション）


###  技術要件

- SwiftUI（macOS 13以上前提）
- `URLSession` を使ってRSSのXMLデータを取得する
- `XMLParser` または他の方法でパースして、`RSSItem`の配列に変換
- UIはすべてSwiftUIで構成（AppDelegateやStoryboardは使わない）


### ️ オプション（優先度低・時間があれば）

- 最初の5件のみ表示
- 既読タイトルをグレー表示
- 複数RSSの統合（複数URLから取得）



##  出力形式

- 完全なXcodeプロジェクトとして作成。
- 適宜コメントを含めて可読性を確保する



