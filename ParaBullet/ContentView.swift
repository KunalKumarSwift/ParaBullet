//
//  ContentView.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-09.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var presentSheet = false
    let showShare: Bool

    init(showShare: Bool = true) {
        self.showShare = showShare
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    sourceTextSection
                    bulletStyleSection
                    convertButtonSection
                    resultSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .padding(.bottom, 100)
            }
        }
        .overlay(
            VStack(spacing: 0.0) {
                Spacer()
                footer
            }
        )
        .appPageStyle()
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("ParaBullet")
                    .font(.aptos(32, weight: .bold))
                    .textGradient(colors: [.appPrimary, .appSecondary], startPoint: .leading, endPoint: .trailing)
                
                Text("Offline • Pro • No Ads")
                    .font(.aptos(10, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.6))
                    .tracking(2)
            }
            
            Spacer()
            
            Button {
                // Settings action
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
                    .frame(width: 44, height: 44)
                    .background(Color.surface)
                    .foregroundColor(.secondary)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    private var sourceTextSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Source Text")
                    .font(.aptos(14, weight: .semiBold))
                    .foregroundColor(.secondary)
                Spacer()
                Button("Clear") {
                    viewModel.inputParagraph = ""
                    viewModel.bulletPoints = []
                }
                .font(.aptos(12, weight: .regular))
                .foregroundColor(.appPrimary)
                .buttonStyle(.plain)
            }
            
            TextEditor(text: $viewModel.inputParagraph)
                .frame(height: 180)
                .padding(12)
                .scrollContentBackground(.hidden) // Remove default macOS background
                .background(Color.surface.opacity(0.5))
                .cornerRadius(20)
                .appBorder()
        }
    }

    private var bulletStyleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Bullet Style")
                .font(.aptos(14, weight: .semiBold))
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    BulletStyleButton(tag: "•", isSelected: viewModel.selectedBulletType == "•") {
                        viewModel.selectedBulletType = "•"
                    }
                    BulletStyleButton(tag: "1.", isSelected: viewModel.selectedBulletType == "Numbered List") {
                        viewModel.selectedBulletType = "Numbered List"
                    }
                    BulletStyleButton(tag: "⭐️", isSelected: viewModel.selectedBulletType == "⭐️") {
                        viewModel.selectedBulletType = "⭐️"
                    }
                    BulletStyleButton(tag: "✅", isSelected: viewModel.selectedBulletType == "✅") {
                        viewModel.selectedBulletType = "✅"
                    }
                    BulletStyleButton(tag: "➡️", isSelected: viewModel.selectedBulletType == "➡️") {
                        viewModel.selectedBulletType = "➡️"
                    }
                }
            }
        }
    }

    private var convertButtonSection: some View {
        VStack(spacing: 16) {
            ActionButton(title: "CONVERT NOW", icon: "bolt.fill") {
                viewModel.bulletPoints = viewModel.paragraphToBulletPoints(viewModel.inputParagraph)
            }
            
            Toggle(isOn: $viewModel.addExtraSpace) {
                Text("Add spacing between items")
                    .font(.aptos(12))
                    .foregroundColor(.secondary)
            }
            .toggleStyle(CheckboxToggleStyle())
        }
    }

    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Result")
                    .font(.aptos(14, weight: .semiBold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("Auto-Generated")
                    .font(.aptos(10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.appPrimary.opacity(0.1))
                    .foregroundColor(.appPrimary)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.bulletPoints.isEmpty {
                    Text("Result will appear here...")
                        .font(.aptos(14))
                        .foregroundColor(.secondary.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 40)
                } else {
                    ForEach(viewModel.bulletPoints, id: \.self) { point in
                        HStack(alignment: .top, spacing: 12) {
                            Text(viewModel.selectedBulletType == "Numbered List" ? "" : viewModel.selectedBulletType)
                                .foregroundColor(.appPrimary)
                            Text(point)
                                .font(.aptos(14))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appCard)
            .cornerRadius(20)
            .appBorder()
        }
    }

    private var footer: some View {
        VStack(spacing: 0.0) {
            Divider()
                .frame(height: 2)       // thickness of the divider
                .background(Color.appPrimary)
            HStack(spacing: 12) {
                ActionButton(title: "Copy All", icon: "doc.on.doc.fill", action: {
                    viewModel.copyToClipboard()
                }, isPrimary: false)
                //.background(Color.primary.opacity(0.9)) // Dark in light mode, Light in dark mode? No, simplified
                .colorInvert() // Simple way to match the 'stitch' design where button is dark

                if showShare {
                    Button {
                        viewModel.shareList()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .frame(width: 56, height: 56)
                            .background(Color.surface)
                            .foregroundColor(.secondary)
                            .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(24)
            .background(
                Color.surface
                    .background(Blur())
                    .ignoresSafeArea()
            )
        }
    }
}

// Helper components
#if os(iOS)
struct Blur: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemThinMaterial)
    }
}
#elseif os(macOS)
struct Blur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .headerView // Appropriate for footer/header in macOS
        view.blendingMode = .withinWindow
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .headerView
    }
}
#endif

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .appPrimary : .secondary)
                configuration.label
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
