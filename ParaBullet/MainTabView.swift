//
//  MainTabView.swift
//  ParaBullet
//
//  Created by Antigravity on 2026-02-15.
//

import SwiftUI

struct MainTabView: View {
    @State private var isAISupported = false

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Bullet Points", systemImage: "list.bullet")
                }
            
            if isAISupported {
                if #available(iOS 26.0, macOS 26.0, *) {
                    SummarizationView()
                        .tabItem {
                            Label("Summarize", systemImage: "sparkles")
                        }
                }
            }
        }
        .tint(.appPrimary)
        .onAppear {
            isAISupported = SummarizationViewModel.isSupported
        }
    }
}

#Preview {
    MainTabView()
}
