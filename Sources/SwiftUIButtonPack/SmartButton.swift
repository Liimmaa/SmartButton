//
//  SmartButton.swift
//  SwiftUIButtonPack
//
//  Created by Chioma Amanda Mmegwa  on 14/04/2025.
//

import SwiftUI

public struct SmartButton: View {
    public enum ButtonStyleType {
        case solid
        case gradient(LinearGradient)
        case glass(backgroundOpacity: Double, strokeColor: Color)
        case neumorphic(lightShadow: Color = Color(uiColor: .systemBackground).opacity(0.8), darkShadow: Color = Color.black.opacity(0.2))
        case outline(borderColor: Color = .blue, borderWidth: CGFloat = 1)
    }

    public enum CornerStyle {
        case rounded(CGFloat)
        case capsule
    }

    public var title: String
    public var fullWidth: Bool
    public var adaptiveWidth: Bool
    public var height: CGFloat?
    public var backgroundColor: Color
    public var foregroundColor: Color
    public var cornerStyle: CornerStyle
    public var font: Font

    public var iconName: String?
    public var iconSize: CGFloat
    public var iconSpacing: CGFloat

    public var style: ButtonStyleType

    public var action: (() -> Void)?
    public var asyncAction: (() async -> Void)?

    public var isDisabled: Bool

    @State private var isLoading = false

    public init(
        title: String,
        fullWidth: Bool = true,
        adaptiveWidth: Bool = false,
        height: CGFloat? = nil,
        backgroundColor: Color = Color.accentColor,
        foregroundColor: Color = Color.primary,
        cornerStyle: CornerStyle = .rounded(12),
        font: Font = .headline,
        iconName: String? = nil,
        iconSize: CGFloat = 18,
        iconSpacing: CGFloat = 8,
        style: ButtonStyleType = .solid,
        isDisabled: Bool = false,
        action: (() -> Void)? = nil,
        asyncAction: (() async -> Void)? = nil
    ) {
        self.title = title
        self.fullWidth = fullWidth
        self.adaptiveWidth = adaptiveWidth
        self.height = height
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerStyle = cornerStyle
        self.font = font
        self.iconName = iconName
        self.iconSize = iconSize
        self.iconSpacing = iconSpacing
        self.style = style
        self.isDisabled = isDisabled
        self.action = action
        self.asyncAction = asyncAction
    }

    public var body: some View {
        Button {
            if let asyncAction {
                Task {
                    guard !isLoading else { return }
                    isLoading = true
                    await asyncAction()
                    isLoading = false
                }
            } else if let action {
                action()
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        } label: {
            ZStack {
                HStack(spacing: iconSpacing) {
                    if let iconName {
                        Image(systemName: iconName)
                            .font(.system(size: iconSize))
                    }
                    Text(title)
                        .font(font)
                }
                .opacity(0)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                } else {
                    HStack(spacing: iconSpacing) {
                        if let iconName {
                            Image(systemName: iconName)
                                .font(.system(size: iconSize))
                        }
                        Text(title)
                            .font(font)
                    }
                }
            }
            .foregroundColor(isDisabled ? .gray : foregroundColor)
            .frame(
                maxWidth: fullWidth ? .infinity : (adaptiveWidth ? nil : .infinity),
                minHeight: height,
                maxHeight: height
            )
            .padding()
            .background(backgroundContainer)
            .clipShape(cornerShape)
            .overlay(borderOverlay)
            .shadow(color: isDisabled ? .clear : shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
        }
        .disabled(isLoading || isDisabled)
    }

    @ViewBuilder
    private var backgroundContainer: some View {
        if isDisabled {
            Color.gray.opacity(0.5)
        } else {
            backgroundView
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .solid:
            backgroundColor
        case .gradient(let gradient):
            gradient
        case .glass(let opacity, _):
            ZStack {
                Color.white.opacity(opacity).blur(radius: 10)
                    .background(.ultraThinMaterial)
            }
        case .neumorphic:
            backgroundColor
        case .outline:
            backgroundColor.opacity(0.05)
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch style {
        case .glass(_, let strokeColor):
            cornerShape
                .stroke(strokeColor, lineWidth: 1)
        case .outline(let borderColor, let borderWidth):
            cornerShape
                .stroke(borderColor, lineWidth: borderWidth)
        default:
            EmptyView()
        }
    }

    private var cornerShape: some Shape {
        switch cornerStyle {
        case .rounded(let radius):
            return AnyShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        case .capsule:
            return AnyShape(Capsule())
        }
    }

    private var shadowColor: Color {
        switch style {
        case .neumorphic(_, let dark):
            return dark
        case .solid:
            return backgroundColor.opacity(0.3)
        case .gradient:
            return backgroundColor.opacity(0.3)
        default:
            return .clear
        }
    }

    private var shadowRadius: CGFloat {
        switch style {
        case .neumorphic:
            return 6
        case .solid, .gradient:
            return 5
        default:
            return 0
        }
    }

    private var shadowX: CGFloat {
        switch style {
        case .neumorphic:
            return 6
        default:
            return 0
        }
    }

    private var shadowY: CGFloat {
        switch style {
        case .neumorphic:
            return 6
        default:
            return 4
        }
    }
}

struct AnyShape: Shape, @unchecked Sendable {
    private let pathBuilder: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self.pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        VStack(spacing: 20) {
            Text("SmartButton Styles")
                .font(.largeTitle.weight(.heavy))
                .foregroundStyle(LinearGradient(colors: [.white, .black], startPoint: .leading, endPoint: .trailing))
                .padding(.bottom, 20)
            
            SmartButton(
                title: "Login with Apple",
                fullWidth: false,
                height: 20,
                backgroundColor: .pink,
                foregroundColor: .white,
                font: .body,
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Login with Apple",
                height: 40,
                backgroundColor: .black,
                foregroundColor: .white,
                font: .body,
                iconName: "apple.logo",
                iconSpacing: 16,
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Gradient Button",
                height: 50,
                foregroundColor: .white,
                iconName: "flame.fill",
                style: .gradient(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                ),
                asyncAction: {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                }
            )

            SmartButton(
                title: "Glass Button",
                height: 50,
                foregroundColor: .white,
                iconName: "snowflake",
                style: .glass(backgroundOpacity: 0.25, strokeColor: Color.white.opacity(0.5)),
                asyncAction: {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                }
            )

            SmartButton(
                title: "Neumorphic",
                height: 50,
                backgroundColor: Color(.systemGray6),
                foregroundColor: .primary,
                style: .neumorphic(),
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Outline",
                height: 30,
                foregroundColor: .white,
                style: .outline(borderColor: .white),
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Capsule Tag",
                fullWidth: false,
                adaptiveWidth: true,
                backgroundColor: .green,
                foregroundColor: .white,
                cornerStyle: .capsule,
                font: .subheadline,
                style: .solid,
                action: {
                    print("Tag tapped")
                }
            )
        }
        .padding()
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        VStack(spacing: 20) {
            Text("SmartButton Styles")
                .font(.largeTitle.weight(.heavy))
                .foregroundStyle(LinearGradient(colors: [.white, .black], startPoint: .leading, endPoint: .trailing))
                .padding(.bottom, 20)

            SmartButton(
                title: "Login with Apple",
                fullWidth: false,
                height: 20,
                backgroundColor: .pink,
                foregroundColor: .white,
                font: .body,
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Login with Apple",
                height: 40,
                backgroundColor: .black,
                foregroundColor: .white,
                font: .body,
                iconName: "apple.logo",
                iconSpacing: 16,
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Gradient Button",
                height: 50,
                foregroundColor: .white,
                iconName: "flame.fill",
                style: .gradient(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                ),
                asyncAction: {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                }
            )

            SmartButton(
                title: "Glass Button",
                height: 50,
                foregroundColor: .white,
                iconName: "snowflake",
                style: .glass(backgroundOpacity: 0.25, strokeColor: Color.white.opacity(0.5)),
                asyncAction: {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                }
            )

            SmartButton(
                title: "Neumorphic",
                height: 50,
                backgroundColor: Color(.systemGray6),
                foregroundColor: .primary,
                style: .neumorphic(),
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Outline",
                height: 30,
                foregroundColor: .white,
                style: .outline(borderColor: .white),
                action: {
                    print("Tapped")
                }
            )

            SmartButton(
                title: "Capsule Tag",
                fullWidth: false,
                adaptiveWidth: true,
                backgroundColor: .green,
                foregroundColor: .white,
                cornerStyle: .capsule,
                font: .subheadline,
                style: .solid,
                action: {
                    print("Tag tapped")
                }
            )
        }
        .padding()
    }
}
