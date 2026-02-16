//
//  SummarizationView.swift
//  ParaBullet
//
//  Created by Antigravity on 2026-02-15.
//

import SwiftUI

@available(iOS 26.0, macOS 26.0, *)
struct SummarizationView: View {
    @StateObject private var viewModel = SummarizationViewModel()
    @FocusState private var isTextEditorFocused: Bool
    @State private var isKeyboardVisible = false

    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    sourceTextSection
                    tokenGuardrailSection
                    convertButtonSection
                    resultSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .padding(.bottom, 100)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .overlay(
            VStack(spacing: 0.0) {
                Spacer()
                if !isKeyboardVisible {
                    footer
                }
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isTextEditorFocused = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isTextEditorFocused = false
                }
            }
        }
#if os(iOS)
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillShowNotification
            )
        ) { _ in
            isKeyboardVisible = true
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification
            )
        ) { _ in
            isKeyboardVisible = false
        }
#endif
        .appPageStyle()
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("ParaBullet")
                    .font(.aptos(32, weight: .bold))
                    .textGradient(
                        colors: [.appPrimary, .appSecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                Text("AI Summarizer • Real-time • Pro")
                    .font(.aptos(10, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.6))
                    .tracking(2)
            }

            Spacer()

            Button {
                isTextEditorFocused = false
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

    // MARK: - Source Text
    private var sourceTextSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Source Text")
                    .font(.aptos(14, weight: .semiBold))
                    .foregroundColor(.secondary)

                Spacer()

                Button("Clear") {
                    viewModel.clear()
                    isTextEditorFocused = false
                }
                .font(.aptos(12, weight: .regular))
                .foregroundColor(.appPrimary)
                .buttonStyle(.plain)
            }

            TextEditor(text: $viewModel.inputText)
                .focused($isTextEditorFocused)
                .frame(height: 180)
                .padding(12)
                .scrollContentBackground(.hidden)
                .background(Color.surface.opacity(0.5))
                .cornerRadius(20)
                .appBorder()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(viewModel.isOverLimit ? Color.red.opacity(0.5) : Color.clear, lineWidth: 2)
                )
        }
    }

    // MARK: - Token Guardrail
    private var tokenGuardrailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Content Window")
                    .font(.aptos(14, weight: .semiBold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(viewModel.tokenCount) / \(viewModel.tokenLimit)")
                    .font(.aptos(12, weight: .bold))
                    .foregroundColor(viewModel.isOverLimit ? .red : .appPrimary)
            }
            
            ProgressView(value: Double(viewModel.tokenCount), total: Double(viewModel.tokenLimit))
                .tint(viewModel.isOverLimit ? .red : .appPrimary)
            
            if viewModel.isOverLimit {
                Text("Text is nearing the on-device model's limit.")
                    .font(.aptos(10, weight: .bold))
                    .foregroundColor(.red)
            }
        }
    }

    // MARK: - Action Buttons
    private var convertButtonSection: some View {
        VStack(spacing: 16) {
            ActionButton(
                title: viewModel.isSummarizing ? "SUMMARIZING..." : "SUMMARIZE NOW",
                icon: viewModel.isSummarizing ? nil : "sparkles"
            ) {
                isTextEditorFocused = false
                viewModel.summarize()
            }
            .disabled(viewModel.isSummarizing || viewModel.inputText.isEmpty)
            .opacity(viewModel.isSummarizing || viewModel.inputText.isEmpty ? 0.6 : 1.0)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.aptos(12, weight: .bold))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }

    // MARK: - Result
    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("AI Summary")
                    .font(.aptos(14, weight: .semiBold))
                    .foregroundColor(.secondary)

                Spacer()

                if viewModel.isSummarizing {
                    Text("Generating...")
                        .font(.aptos(10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.appSecondary.opacity(0.1))
                        .foregroundColor(.appSecondary)
                        .cornerRadius(4)
                } else {
                    Text("Powered by AI")
                        .font(.aptos(10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.appPrimary.opacity(0.1))
                        .foregroundColor(.appPrimary)
                        .cornerRadius(4)
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                if viewModel.summary.isEmpty && !viewModel.isSummarizing {
                    Text("Summary will appear here...")
                        .font(.aptos(14))
                        .foregroundColor(.secondary.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 40)
                } else {
                    Text(viewModel.summary)
                        .font(.aptos(14))
                        .lineSpacing(6)
                        .contentTransition(.opacity)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassStyle()
            .aiGlow(isActive: viewModel.isSummarizing)
            .animation(Animation.spring(), value: viewModel.isSummarizing)
        }
    }

    // MARK: - Footer
    private var footer: some View {
        VStack(spacing: 0.0) {
            Divider()
                .frame(height: 2)
                .background(
                    LinearGradient(
                        colors: [.appPrimary, .appSecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            HStack(spacing: 12) {
                ActionButton(
                    title: "Copy Summary",
                    icon: "doc.on.doc.fill",
                    action: {
                        isTextEditorFocused = false
                        viewModel.copyToClipboard()
                    },
                    isPrimary: false
                )
                .colorInvert()
                .disabled(viewModel.summary.isEmpty)
                .opacity(viewModel.summary.isEmpty ? 0.6 : 1.0)

                Button {
                    isTextEditorFocused = false
                    viewModel.shareSummary()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .frame(width: 56, height: 56)
                        .background(Color.surface)
                        .foregroundColor(.secondary)
                        .cornerRadius(16)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.summary.isEmpty)
                .opacity(viewModel.summary.isEmpty ? 0.6 : 1.0)
            }
            .padding(24)
            .background(
                AppBlurView()
                    .background(Color.surface.opacity(0.8))
                    .ignoresSafeArea()
            )
        }
    }
}

// MARK: - Custom Modifiers & Views

private struct GlassmorphismStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.surface.opacity(0.4))
                    .background(AppBlurView())
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct AIGlowModifier: ViewModifier {
    let isActive: Bool
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isActive {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.appPrimary, .appSecondary, .appPrimary.opacity(0)]),
                                    center: .center,
                                    angle: .degrees(rotation)
                                ),
                                lineWidth: 4
                            )
                            .blur(radius: 8)
                            .opacity(0.8)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.appPrimary, .appSecondary, .appPrimary.opacity(0)]),
                                    center: .center,
                                    angle: .degrees(rotation)
                                ),
                                lineWidth: 2
                            )
                    }
                }
            )
            .shadow(color: .appPrimary.opacity(isActive ? 0.3 : 0), radius: 15, x: 0, y: 0)
            .onAppear {
                if isActive {
                    startAnimation()
                }
            }
            .onChange(of: isActive) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    rotation = 0
                }
            }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
}

#if os(iOS)
private struct AppBlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#elseif os(macOS)
private struct AppBlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .withinWindow
        view.material = .hudWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .hudWindow
    }
}
#endif

extension View {
    fileprivate func glassStyle() -> some View {
        self.modifier(GlassmorphismStyle())
    }
    
    fileprivate func aiGlow(isActive: Bool) -> some View {
        self.modifier(AIGlowModifier(isActive: isActive))
    }
}

#Preview {
    if #available(iOS 26.0, macOS 26.0, *) {
        SummarizationView()
    } else {
        Text("AI Summarizer requires macOS 26.0 or newer.")
    }
}
