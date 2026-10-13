//
// OnboardingView.swift
// bitchat
//

import SwiftUI

struct OnboardingView: View {
    var onComplete: (String) -> Void

    @State private var page = 0
    @State private var nickname = ""
    @State private var showNicknameError = false
    @ThemedPalette private var palette

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                welcome.tag(0)
                howItWorks.tag(1)
                nicknameStep.tag(2)
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .always))
            #endif
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if page < 2 {
                Button(action: { page += 1 }) {
                    Text(verbatim: "Next")
                        .bitchatFont(size: 17, weight: .semibold)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(palette.accent)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .accessibilityHint(Text(verbatim: "Shows the next introduction screen"))
            }
        }
        .foregroundColor(palette.primary)
        .background(ThemedRootBackground())
    }

    private var welcome: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(verbatim: AggieLinkConfig.displayName)
                    .bitchatFont(size: 34, weight: .bold)
                    .accessibilityAddTraits(.isHeader)
                Text(verbatim: AggieLinkConfig.tagline)
                    .bitchatFont(size: 20, weight: .semibold)
                Text(verbatim: AggieLinkCopy.welcomeBody)
                    .bitchatFont(size: 17)
                    .fixedSize(horizontal: false, vertical: true)
                Text(verbatim: AggieLinkCopy.occasion)
                    .bitchatFont(size: 15, weight: .medium)
                    .foregroundColor(palette.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
    }

    private var howItWorks: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(verbatim: AggieLinkCopy.howItWorksTitle)
                    .bitchatFont(size: 28, weight: .bold)
                    .accessibilityAddTraits(.isHeader)
                ForEach(Array(AggieLinkCopy.limits.enumerated()), id: \.offset) { _, line in
                    Text(verbatim: line)
                        .bitchatFont(size: 17)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
    }

    private var nicknameStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(verbatim: AggieLinkCopy.nicknamePrompt)
                    .bitchatFont(size: 28, weight: .bold)
                    .accessibilityAddTraits(.isHeader)
                Text(verbatim: AggieLinkCopy.nicknameHint)
                    .bitchatFont(size: 15)
                    .foregroundColor(palette.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                TextField("Nickname", text: $nickname)
                    .textFieldStyle(.roundedBorder)
                    .bitchatFont(size: 17)
                    .autocorrectionDisabled(true)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .accessibilityLabel(Text(verbatim: "Nickname"))
                if showNicknameError {
                    Text(verbatim: AggieLinkCopy.nicknameInvalid)
                        .bitchatFont(size: 14)
                        .foregroundColor(palette.alertRed)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(verbatim: AggieLinkCopy.acceptableUse)
                    .bitchatFont(size: 15)
                    .foregroundColor(palette.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Button(action: submit) {
                    Text(verbatim: AggieLinkCopy.bluetoothButton)
                        .bitchatFont(size: 17, weight: .semibold)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(palette.accent)
                Text(verbatim: AggieLinkCopy.bluetoothCaption)
                    .bitchatFont(size: 14)
                    .foregroundColor(palette.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
    }

    private func submit() {
        let valid = InputValidator.validateNickname(nickname) != nil
        showNicknameError = !valid
        guard valid else { return }
        onComplete(nickname)
    }
}
