//
//  MenuView.swift
//  QuickFeed
//
//  Created by sora on 2025/06/26.
//

import SwiftUI

/// メニューバーのドロップダウンメニューを表示するビュー
struct MenuView: View {
    @EnvironmentObject var feedManager: RSSFeedManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ヘッダー
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .foregroundColor(.orange)
                Text("QuickFeed")
                    .font(.headline)
                Spacer()
                
                // 更新ボタン
                Button(action: {
                    feedManager.fetchFeed()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .help("フィードを更新")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Divider()
            
            // ローディング表示
            if feedManager.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("読み込み中...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            
            // エラー表示
            if let errorMessage = feedManager.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            
            // RSSアイテム一覧
            if feedManager.rssItems.isEmpty && !feedManager.isLoading {
                Text("フィードが見つかりません")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(feedManager.rssItems.sorted { 
                            ($0.pubDate ?? Date.distantPast) > ($1.pubDate ?? Date.distantPast) 
                        }.prefix(20)) { item in
                            RSSItemView(item: item) {
                                feedManager.openURL(item.link)
                            }
                            
                            let sortedItems = feedManager.rssItems.sorted { 
                                ($0.pubDate ?? Date.distantPast) > ($1.pubDate ?? Date.distantPast) 
                            }.prefix(20)
                            if item.id != sortedItems.last?.id {
                                Divider()
                                    .padding(.leading, 12)
                            }
                        }
                    }
                }
                .frame(maxHeight: 400)
            }
            
            Divider()
            
            // フッター
            HStack {
                Text("最終更新: \(formatLastUpdate())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Button("終了") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(PlainButtonStyle())
                .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .frame(width: 360)
    }
    
    private func formatLastUpdate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

/// 個別のRSSアイテムを表示するビュー
struct RSSItemView: View {
    let item: RSSItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Text(item.pubDate != nil ? formatDate(item.pubDate!) : "日付不明")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { isHovered in
            if isHovered {
                NSCursor.pointingHand.set()
            } else {
                NSCursor.arrow.set()
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}