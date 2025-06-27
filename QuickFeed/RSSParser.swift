//
//  RSSParser.swift
//  QuickFeed
//
//  Created by sora on 2025/06/26.
//

import Foundation

/// RSSフィードのXMLを解析するクラス
class RSSParser: NSObject, XMLParserDelegate {
    private var items: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentPubDate = ""
    private var isInsideItem = false
    
    /// XMLデータからRSSアイテムの配列を解析する
    func parseRSSFeed(data: Data) -> [RSSItem] {
        items.removeAll()
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        return items
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            isInsideItem = true
            currentTitle = ""
            currentLink = ""
            currentPubDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isInsideItem {
            switch currentElement {
            case "title":
                currentTitle += trimmedString
            case "link":
                currentLink += trimmedString
            case "pubDate":
                currentPubDate += trimmedString
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" && isInsideItem {
            // 日付のパース
            let pubDate = parsePubDate(currentPubDate)
            
            // RSSItemを作成して配列に追加
            if !currentTitle.isEmpty && !currentLink.isEmpty {
                let rssItem = RSSItem(
                    title: currentTitle,
                    link: currentLink,
                    pubDate: pubDate
                )
                items.append(rssItem)
            }
            
            isInsideItem = false
        }
    }
    
    /// 日付文字列をDateオブジェクトに変換
    private func parsePubDate(_ dateString: String) -> Date? {
        if dateString.isEmpty { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ソフトアンテナ形式（例: "2025-06-26 01:31:30 UTC"）
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        
        // RFC 2822形式（例: "Wed, 25 Jun 2025 10:30:00 +0900"）
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        dateFormatter.timeZone = nil
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        
        // 別の形式も試す
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        return dateFormatter.date(from: dateString)
    }
}