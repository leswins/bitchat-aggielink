//
// AggieLinkOnboarding.swift
// bitchat
//
// First-launch gate. The nickname is written to the same UserDefaults key
// ChatViewModel reads (`bitchat.nickname`) before the runtime is created, so
// the mesh starts with the name the person chose.
//

import Foundation

enum AggieLinkOnboarding {
    static let completedKey = "aggielink.onboardingComplete"
    /// Must stay aligned with `ChatViewModel`'s nickname storage key.
    static let nicknameKey = "bitchat.nickname"

    static func isComplete(in defaults: UserDefaults = .standard) -> Bool {
        defaults.bool(forKey: completedKey)
    }

    /// Writes a validated nickname and leaves the completion flag untouched.
    /// Returns false and writes nothing when the nickname is empty or rejected.
    @discardableResult
    static func saveNickname(_ nickname: String, defaults: UserDefaults = .standard) -> Bool {
        guard let valid = InputValidator.validateNickname(nickname) else { return false }
        defaults.set(valid, forKey: nicknameKey)
        return true
    }

    static func markComplete(defaults: UserDefaults = .standard) {
        defaults.set(true, forKey: completedKey)
    }

    /// Saves a validated nickname and marks onboarding complete.
    /// Returns false and writes nothing when the nickname is empty or rejected.
    @discardableResult
    static func complete(nickname: String, defaults: UserDefaults = .standard) -> Bool {
        guard saveNickname(nickname, defaults: defaults) else { return false }
        markComplete(defaults: defaults)
        return true
    }
}
