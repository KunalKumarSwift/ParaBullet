//
//  ParaBulletApp.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-09.
//

import SwiftUI

@main
struct ParaBulletApp: App {
    @State var inputParagraph = ""
    @State var bulletPoints: [String] = []
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        MenuBarExtra("ParaBullet", systemImage: "rectangle.and.pencil.and.ellipsis", isInserted: $showMenuBarExtra) {
            Group {
                ContentView(showShare: false)
                    .frame(minWidth: 250.0, minHeight: 600.0)
            }

        }.menuBarExtraStyle(.window)
        #endif


    }
#if os(iOS)
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
#endif
}
