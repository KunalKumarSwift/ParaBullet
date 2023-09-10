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
            HStack {
                TextEditor(text: $inputParagraph)
                    .frame(minWidth: 300, minHeight: 150)
                    .cornerRadius(8)
                    .padding()
                List(bulletPoints, id: \.self, rowContent: { point in
                    Text(point)
                })
                .frame(minWidth: 300, minHeight: 150)
                .cornerRadius(8)
                .padding()
            }

            VStack {

                Picker("Select Bullet Type", selection: $selectedBulletType) {
                                    Text("•").tag("•")
                                    Text("Numbered List").tag("Numbered List")
                                    Text("➡️").tag("➡️")
                                    Text("⭐️").tag("⭐️")
                                    Text("✅").tag("✅")
                                    Text("⚽️").tag("⚽️")
                                    Text("🏀").tag("🏀")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()

                HStack {
                    Toggle("Add Extra Space", isOn: $addExtraSpace) // Checkbox to control extra space
                                       .padding()

                    Button("Convert to Bullet Points") {
                        bulletPoints = paragraphToBulletPoints(inputParagraph)
                    }
                    .padding()

                    Button("Copy to Clipboard") {
                        copyToClipboard()
                    }
                    .padding()
                }

            }
        }
        .padding()
    }

    var extraSpace: String {
        return $addExtraSpace.wrappedValue == true ? "\n" : ""
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
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(bulletPointsText, forType: .string)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
