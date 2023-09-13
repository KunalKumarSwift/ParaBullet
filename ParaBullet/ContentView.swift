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

    var body: some View {
        GeometryReader { proxy in
            AdaptableScrollView {
                VStack {
                    Text("ParaBullet")
                        .font(.title)
                        .bold()
                        .textGradient(colors:
                                        [
                                            Color.green,
                                            Color.blue
                                        ],
                                      startPoint: .topLeading,
                                      endPoint: .topTrailing
                        )
                    textWithListView(proxy: proxy)
                        .frame(maxHeight: .infinity)
                        .padding()

                    VStack(alignment: .leading) {
                        Text("Select Bullet Type:")
                        Picker("", selection: $viewModel.selectedBulletType) {
                            Text("•").tag("•")
                            Text("Numbered List").tag("Numbered List")
                            Text("➡️").tag("➡️")
                            Text("⭐️").tag("⭐️")
                            Text("✅").tag("✅")
                            Text("⚽️").tag("⚽️")
                            Text("🏀").tag("🏀")
                        }
                        .adaptablePickerStyle(geometry: proxy, widthThreshold: 450)
#if os(iOS)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accentColor, lineWidth: 1)
                        )
#endif

                        AdaptableStack(proxy, widthThreshold: 450) {
                            Toggle(isOn: $viewModel.addExtraSpace) {
                                Text("Add Extra Space")
                            }
                            HStack {
                                Button("Create Bullet Points") {
                                    viewModel.bulletPoints = viewModel.paragraphToBulletPoints(viewModel.inputParagraph)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()

#if os(iOS)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.accentColor, lineWidth: 1)
                                )
#endif

                                Button("Copy to Clipboard") {
                                    viewModel.copyToClipboard()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()

#if os(iOS)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.accentColor, lineWidth: 1)
                                )
#endif
                            }
                            HStack {
                                Button("Clear Text") {
                                    viewModel.inputParagraph = ""
                                    viewModel.bulletPoints = []
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
#if os(iOS)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.accentColor, lineWidth: 1)
                                )
#endif

                                Button("Share List") {
                                    viewModel.shareList()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
#if os(iOS)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.accentColor, lineWidth: 1)
                                ).frame(maxWidth: .infinity)
#endif
                            }
                        }

                    }.padding()
                }
            }
            .background(Color("Background"))
#if os(macOS)
            .alert(isPresented: $viewModel.isAlertPresented) {
                Alert(
                    title: Text("Error"),
                    message: Text("Key window is not available."),
                    dismissButton: .default(Text("OK"))
                )
            }
#endif
        }
    }

    var textEditor: some View {
        return TextEditor(text: $viewModel.inputParagraph)
            .cornerRadius(16)
#if os(iOS)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                ToolbarItem(placement: .keyboard) {
                    VStack(alignment: .trailing) {
                        Button("Done") {
                            hideKeyboard()
                        }
                    }
                }
            }

            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondary, lineWidth: 1)
            )
#endif
    }

    var list: some View {
        List(viewModel.bulletPoints, id: \.self, rowContent: { point in
            Text(point)
                .listRowBackground(Color.clear)
        })
        .cornerRadius(16)
#if os(iOS)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary, lineWidth: 1)
        )
#endif
    }

    func textWithListView(proxy: GeometryProxy) -> some View {

        AdaptableStack(proxy) {
            textEditor
            list
        }
        .frame(minWidth: (proxy.size.width / 2.5), idealHeight: minimumHeight(proxy: proxy))
    }

    func minimumHeight(proxy: GeometryProxy) -> CGFloat {
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return proxy.size.height * 0.75
        } else {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                return proxy.size.height * 0.70
            } else {
                return proxy.size.height * 0.70
            }
        }
#else
        return 150.0
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
