//
//  ContentView.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-09.
//

import SwiftUI

struct ContentView: View {
    @State private var inputParagraph = ""
    @State private var bulletPoints: [String] = []
    @State private var isAnimating = false
    @State private var addExtraSpace = false
    @State private var selectedBulletType = "•"

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
                            Picker("", selection: $selectedBulletType) {
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

                            AdaptableStack(proxy, widthThreshold: 1000) {
                                Toggle(isOn: $addExtraSpace) {
                                    Text("Add Extra Space")
                                }
                                Button("Convert to Bullet Points") {
                                    bulletPoints = paragraphToBulletPoints(inputParagraph)
                                }
                                .padding()

#if os(iOS)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.accentColor, lineWidth: 1)
                                    )
#endif

                                Button("Copy to Clipboard") {
                                    copyToClipboard()
                                }
                                .padding()

#if os(iOS)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.accentColor, lineWidth: 1)
                                    )
#endif

                            }

                        }.padding()
                    }
                }.background(Color("Background"))
            }
    }

    var textEditor: some View {
        return TextEditor(text: $inputParagraph)
            .cornerRadius(16)
#if os(iOS)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary, lineWidth: 1)
        )
#endif
    }

    var list: some View {
        List(bulletPoints, id: \.self, rowContent: { point in
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

    var extraSpace: String {
        return $addExtraSpace.wrappedValue == true ? "\n" : ""
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
                 return proxy.size.height * 0.45
            } else {
                return proxy.size.height * 0.50
            }
        }
        #else
        return 150.0
        #endif
    }

    func paragraphToBulletPoints(_ paragraph: String) -> [String] {
        var bulletPoints = [String]()
        var currentSentence = ""
        var counter = 1
        for character in paragraph {
            currentSentence.append(character)

            var bulletPointer = selectedBulletType

            if selectedBulletType == "Numbered List" {
                bulletPointer = "\(counter)"
            }

            if character == "." || character == "?" {
                bulletPoints.append(bulletPointer + "    " + currentSentence.trimmingCharacters(in: .whitespacesAndNewlines) + extraSpace)
                currentSentence = ""
                counter += 1
            }
        }

        return bulletPoints.filter { !$0.isEmpty }
    }

    func copyToClipboard() {
        let bulletPointsText = bulletPoints.joined(separator: "\n")
#if os(iOS)
        let pasteboard = UIPasteboard.general
        pasteboard.string = nil
        pasteboard.string = bulletPointsText
#elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(bulletPointsText, forType: .string)
#else
        print("OMG, it's that mythical new Apple product!!!")
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
