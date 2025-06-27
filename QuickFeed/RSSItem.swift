//
//  RSSItem.swift
//  QuickFeed
//
//  Created by sora on 2025/06/26.
//

import Foundation

/// RSSフィードの各アイテムを表す構造体
struct RSSItem: Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let pubDate: Date?
    
    init(title: String, link: String, pubDate: Date? = nil) {
        self.title = title
        self.link = link
        self.pubDate = pubDate
    }
}