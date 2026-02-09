import SwiftUI

struct ActionButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isPrimary: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.aptos(16, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isPrimary ? Color.appPrimary : Color.surface)
            .foregroundColor(isPrimary ? .white : .primary)
            .cornerRadius(16)
            .shadow(color: isPrimary ? Color.appPrimary.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}

struct BulletStyleButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.aptos(18, weight: .bold))
                .frame(width: 48, height: 48)
                .background(isSelected ? Color.appPrimary : Color.surface)
                .foregroundColor(isSelected ? .white : .secondary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.clear : Color.secondary.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: isSelected ? Color.appPrimary.opacity(0.2) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Action Buttons")
                    .font(.aptos(24, weight: .bold))
                
                ActionButton(title: "CONVERT NOW", icon: "bolt.fill") { }
                
                ActionButton(title: "Copy All", icon: "doc.on.doc.fill", action: { }, isPrimary: false)
                    .background(Color.primary.opacity(0.9))
                    .colorInvert()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Bullet Style Buttons")
                    .font(.aptos(24, weight: .bold))
                
                HStack(spacing: 12) {
                    BulletStyleButton(tag: "•", isSelected: true) { }
                    BulletStyleButton(tag: "1.", isSelected: false) { }
                    BulletStyleButton(tag: "⭐️", isSelected: false) { }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .background(Color.appBackground)
}

#Preview("Dark Mode") {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Action Buttons")
                    .font(.aptos(24, weight: .bold))
                
                ActionButton(title: "CONVERT NOW", icon: "bolt.fill") { }
                
                ActionButton(title: "Copy All", icon: "doc.on.doc.fill", action: { }, isPrimary: false)
                    .background(Color.primary.opacity(0.9))
                    .colorInvert()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Bullet Style Buttons")
                    .font(.aptos(24, weight: .bold))
                
                HStack(spacing: 12) {
                    BulletStyleButton(tag: "•", isSelected: true) { }
                    BulletStyleButton(tag: "1.", isSelected: false) { }
                    BulletStyleButton(tag: "⭐️", isSelected: false) { }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .background(Color.appBackground)
    .preferredColorScheme(.dark)
}
