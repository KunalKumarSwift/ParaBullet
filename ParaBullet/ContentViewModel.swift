//
//  ContentViewModel.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-13.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

class ContentViewModel: ObservableObject {
    @Published var inputParagraph = ""
    @Published var bulletPoints: [String] = []
    @Published var selectedBulletType = "•"
    @Published var addExtraSpace = false
    @Published var isAlertPresented = false

    func paragraphToBulletPoints(_ paragraph: String) -> [String] {
        var bulletPoints = [String]()
        var currentSentence = ""
        var counter = 1

        let sentences = splitIntoSentences(paragraph)

        for sentence in sentences {
            var bulletPointer = selectedBulletType

            if selectedBulletType == "Numbered List" {
                bulletPointer = "\(counter)"
            }

            bulletPoints.append(bulletPointer + "    " + sentence.trimmingCharacters(in: .whitespacesAndNewlines) + extraSpace)
            counter += 1
        }

        return bulletPoints.filter { !$0.isEmpty }


    }

    private func splitIntoSentences(_ text: String) -> [String] {
        let pattern = "(?<=[.!?])\\s+(?=[A-Z])"

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: text.utf16.count)

            var sentences: [String] = []
            var lastIndex = text.startIndex

            regex.enumerateMatches(in: text, options: [], range: range) { (match, flags, stop) in
                if let matchRange = match?.range {
                    let matchRange = Range(matchRange, in: text)!
                    let sentence = String(text[lastIndex..<matchRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                    if !sentence.isEmpty {
                        sentences.append(sentence)
                    }
                    lastIndex = matchRange.upperBound
                }
            }

            // Add the last sentence
            let lastSentence = String(text[lastIndex..<text.endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !lastSentence.isEmpty {
                sentences.append(lastSentence)
            }

            return sentences
        } catch {
            // If regex fails, fallback to splitting by period
            return text.components(separatedBy: ".").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        }
    }


    var extraSpace: String {
        return addExtraSpace ? "\n" : ""
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

    func shareList() {
        let bulletPointsText = bulletPoints.joined(separator: "\n")

#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad && UIApplication.shared.windows.first?.rootViewController?.view == nil {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [bulletPointsText], applicationActivities: nil)
        activityViewController.modalTransitionStyle = .coverVertical
        activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
        activityViewController.popoverPresentationController?.permittedArrowDirections = []

        let screenCenter = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        let sourceRect = CGRect(x: screenCenter.x, y: screenCenter.y, width: 1, height: 1)
        activityViewController.popoverPresentationController?.sourceRect = sourceRect

        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
#elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(bulletPointsText, forType: .string)
        if let contentView = NSApp.keyWindow?.contentView {
            let sharingServicePicker = NSSharingServicePicker(items: [bulletPointsText])
            sharingServicePicker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
        } else {
            isAlertPresented = true
        }
#endif
    }
}
