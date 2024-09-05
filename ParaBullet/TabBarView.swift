//
//  TabBarView.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2024-08-30.
//

import SwiftUI
import ParaBulletStatKit 

struct TabBarView: View {
    @StateObject private var calculator = StatisticsCalculator()

    var body: some View {
        TabView {
            ContentView(showShare: true)
                .tabItem {
                    Label("Content", systemImage: "text.bubble")
                }

            FileSelectionView()
                .readableGuidePadding()
                .environmentObject(calculator) // Inject the StatisticsCalculator as an EnvironmentObject
                .tabItem {
                    Label("File Selection", systemImage: "doc.fill")
                }

        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(statisticsCalculator)
    }
}
