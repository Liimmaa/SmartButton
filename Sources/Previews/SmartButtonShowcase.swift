//
//  SmartButtonShowcase.swift
//  SwiftUIButtonPack
//
//  Created by Chioma Amanda Mmegwa  on 15/04/2025.
//

import SwiftUI

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
