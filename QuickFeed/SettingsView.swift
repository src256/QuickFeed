//
//  SettingsView.swift
//  QuickFeed
//
//  Created by sora on 2025/06/27.
//

import SwiftUI

/// アプリ設定画面のビュー
struct SettingsView: View {
    @EnvironmentObject var feedManager: RSSFeedManager
    @State private var tempFeedURL: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー
            HStack {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("設定")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal)
            
            // RSS URL設定
            VStack(alignment: .leading, spacing: 8) {
                Text("RSS フィード URL")
                    .font(.headline)
                
                TextField("RSS URL を入力", text: $tempFeedURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 13, design: .monospaced))
                
                Text("デフォルト: https://softantenna.com/folders/feed.rss")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // ボタン
            HStack(spacing: 12) {
                Button("キャンセル") {
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("デフォルトに戻す") {
                    tempFeedURL = "https://softantenna.com/folders/feed.rss"
                }
                
                Button("保存") {
                    saveFeedURL()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(width: 400, height: 200)
        .onAppear {
            tempFeedURL = feedManager.feedURL
        }
        .alert("設定", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveFeedURL() {
        guard !tempFeedURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "URLを入力してください"
            showingAlert = true
            return
        }
        
        guard URL(string: tempFeedURL) != nil else {
            alertMessage = "無効なURLです"
            showingAlert = true
            return
        }
        
        feedManager.updateFeedURL(tempFeedURL)
        alertMessage = "設定を保存しました"
        showingAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            dismiss()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(RSSFeedManager())
}