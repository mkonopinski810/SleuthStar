import SwiftUI

struct PrimaryButton: View {
    enum Style {
        case gold
        case parchment
        case ghost
        case danger
    }

    let title: String
    var systemImage: String? = nil
    var style: Style = .gold
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button {
            Haptics.tap()
            action()
        } label: {
            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .bold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .tracking(0.3)
            }
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(strokeColor, lineWidth: 1)
            )
            .shadow(color: shadowColor, radius: 14, y: 6)
            .opacity(isEnabled ? 1.0 : 0.45)
        }
        .disabled(!isEnabled)
        .buttonStyle(PressableButtonStyle())
    }

    private var foreground: Color {
        switch style {
        case .gold: return Theme.midnight
        case .parchment: return Theme.midnight
        case .ghost: return Theme.textPrimary
        case .danger: return .white
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .gold:
            Theme.goldGradient
        case .parchment:
            LinearGradient(colors: [Theme.parchment, Color(red: 0.85, green: 0.78, blue: 0.65)], startPoint: .top, endPoint: .bottom)
        case .ghost:
            Theme.coal.opacity(0.7)
        case .danger:
            LinearGradient(colors: [Theme.bloodRed, Color(red: 0.50, green: 0.13, blue: 0.13)], startPoint: .top, endPoint: .bottom)
        }
    }

    private var strokeColor: Color {
        switch style {
        case .gold: return Theme.goldDeep.opacity(0.7)
        case .parchment: return Color(red: 0.65, green: 0.55, blue: 0.40)
        case .ghost: return Theme.gold.opacity(0.35)
        case .danger: return Color.black.opacity(0.4)
        }
    }

    private var shadowColor: Color {
        switch style {
        case .gold: return Theme.gold.opacity(0.35)
        case .parchment: return Color.black.opacity(0.35)
        case .ghost: return Color.black.opacity(0.4)
        case .danger: return Theme.bloodRed.opacity(0.45)
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        NoirBackground()
        VStack(spacing: 16) {
            PrimaryButton(title: "Investigate", systemImage: "magnifyingglass") {}
            PrimaryButton(title: "Read Notes", systemImage: "doc.text", style: .parchment) {}
            PrimaryButton(title: "Cancel", style: .ghost) {}
            PrimaryButton(title: "Drop Case", systemImage: "xmark", style: .danger) {}
            PrimaryButton(title: "Locked", style: .gold, isEnabled: false) {}
        }
        .padding()
    }
}
