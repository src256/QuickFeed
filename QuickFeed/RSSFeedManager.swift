//
//  RSSFeedManager.swift
//  QuickFeed
//
//  Created by sora on 2025/06/26.
//

import Foundation
import Combine
import AppKit

/// RSSフィードの取得と管理を行うクラス
@MainActor
class RSSFeedManager: ObservableObject {
    @Published var rssItems: [RSSItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let feedURL = "https://softantenna.com/folders/feed.rss"
    private let parser = RSSParser()
    private var timer: Timer?
    
    init() {
        // アプリ起動時にフィードを取得
        fetchFeed()
        // 10分間隔のタイマーを開始
        startAutoUpdate()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    /// RSSフィードを取得する
    func fetchFeed() {
        guard let url = URL(string: feedURL) else {
            errorMessage = "無効なURL: \(feedURL)"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = parser.parseRSSFeed(data: data)
                
                await MainActor.run {
                    self.rssItems = items
                    self.isLoading = false
                }
            } catch {
                print("フィードの取得に失敗: \(error.localizedDescription)")
                await MainActor.run {
                    self.errorMessage = "フィードの取得に失敗しました: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    /// 10分間隔での自動更新を開始
    private func startAutoUpdate() {
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
            Task { @MainActor in
                self.fetchFeed()
            }
        }
    }
    
    /// 自動更新タイマーを停止
    private func stopAutoUpdate() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 指定されたURLをデフォルトブラウザで開く
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            errorMessage = "無効なURL: \(urlString)"
            return
        }
        
        NSWorkspace.shared.open(url)
    }
}
