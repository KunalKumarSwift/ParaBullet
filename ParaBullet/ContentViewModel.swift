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
