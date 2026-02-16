//
//  SummarizationViewModel.swift
//  ParaBullet
//
//  Created by Antigravity on 2026-02-15.
//

import SwiftUI
import FoundationModels // Assuming the framework name from WWDC 2025

@available(iOS 26.0, macOS 26.0, *)
class SummarizationViewModel: ObservableObject {
    static var isSupported: Bool {
        if #available(iOS 26.0, macOS 26.0, *) {
            return SystemLanguageModel.default.availability == .available
        }
        return false
    }
    
    @Published var inputText = "" {
        didSet {
            updateTokenCount()
            checkContentWindow()
        }
    }
    @Published var summary = ""
    @Published var isSummarizing = false
    @Published var errorMessage: String?
    
    @Published var tokenCount = 0
    @Published var tokenLimit = 4096
    @Published var safetyThreshold = 3500 // Leave room for instructions and output
    @Published var isOverLimit = false
    
    private var session: LanguageModelSession?
    
    init() {
        Task {
            await prepareModel()
        }
    }
    
    @MainActor
    private func prepareModel() async {
        do {
            let model = SystemLanguageModel.default
            let instructions = Instructions("You are a helpful assistant that summarizes text concisely. Keep the summary structured and easy to read.")
            self.session = try await LanguageModelSession(model: model, instructions: instructions)
        } catch {
            self.errorMessage = "Failed to initialize foundation model: \(error.localizedDescription)"
        }
    }
    
    func summarize() {
        guard !inputText.isEmpty else { return }
        guard let session = session else {
            errorMessage = "Model not ready."
            return
        }
        
        isSummarizing = true
        errorMessage = nil
        summary = ""
        
        Task {
            do {
                let stream = try await session.streamResponse(to: inputText)
                for try await response in stream {
                    await MainActor.run {
                        self.summary = response.content
                    }
                }
                await MainActor.run {
                    self.isSummarizing = false
                }
            } catch let error as LanguageModelSession.GenerationError {
                await MainActor.run {
                    handleGenerationError(error)
                    self.isSummarizing = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                    self.isSummarizing = false
                }
            }
        }
    }
    
    private func handleGenerationError(_ error: LanguageModelSession.GenerationError) {
        switch error {
        case .guardrailViolation:
            errorMessage = "The content provided violates safety guardrails. Please provide different text."
        case .exceededContextWindowSize:
            errorMessage = "The text is too long for the model to process. Please shorten it."
        default:
            errorMessage = "Failed to generate summary: \(error.localizedDescription)"
        }
    }
    
    private func updateTokenCount() {
        // Heuristic: 1 token ≈ 4 characters for Latin languages
        tokenCount = inputText.count / 4
    }
    
    private func checkContentWindow() {
        if tokenCount > safetyThreshold {
            isOverLimit = true
        } else {
            isOverLimit = false
        }
    }
    
    func clear() {
        inputText = ""
        summary = ""
        errorMessage = nil
    }
    
    func copyToClipboard() {
        guard !summary.isEmpty else { return }
#if os(iOS)
        UIPasteboard.general.string = summary
#elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(summary, forType: .string)
#endif
    }
    
    func shareSummary() {
        guard !summary.isEmpty else { return }
#if os(iOS)
        let activityViewController = UIActivityViewController(activityItems: [summary], applicationActivities: nil)
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            activityViewController.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityViewController, animated: true, completion: nil)
        }
#elseif os(macOS)
        let sharingServicePicker = NSSharingServicePicker(items: [summary])
        if let contentView = NSApp.keyWindow?.contentView {
            sharingServicePicker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
        }
#endif
    }
}
