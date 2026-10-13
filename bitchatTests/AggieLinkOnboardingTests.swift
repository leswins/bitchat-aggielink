//
// AggieLinkOnboardingTests.swift
// bitchatTests
//

import Foundation
import Testing
@testable import bitchat

struct AggieLinkOnboardingTests {
    @Test func incompleteByDefault() throws {
        let defaults = try makeDefaults()
        #expect(!AggieLinkOnboarding.isComplete(in: defaults))
    }

    @Test func saveNicknameLeavesOnboardingIncomplete() throws {
        let defaults = try makeDefaults()
        #expect(AggieLinkOnboarding.saveNickname("  Jordan  ", defaults: defaults))
        #expect(!AggieLinkOnboarding.isComplete(in: defaults))
        #expect(defaults.string(forKey: AggieLinkOnboarding.nicknameKey) == "Jordan")
    }

    @Test func completeStoresNicknameAndFlag() throws {
        let defaults = try makeDefaults()
        #expect(AggieLinkOnboarding.complete(nickname: "  Jordan  ", defaults: defaults))
        #expect(AggieLinkOnboarding.isComplete(in: defaults))
        #expect(defaults.string(forKey: AggieLinkOnboarding.nicknameKey) == "Jordan")
    }

    @Test func completeRejectsEmptyAndControlCharacters() throws {
        let defaults = try makeDefaults()
        #expect(!AggieLinkOnboarding.complete(nickname: "   ", defaults: defaults))
        #expect(!AggieLinkOnboarding.complete(nickname: "bad\nname", defaults: defaults))
        #expect(!AggieLinkOnboarding.isComplete(in: defaults))
        #expect(defaults.string(forKey: AggieLinkOnboarding.nicknameKey) == nil)
    }

    private func makeDefaults() throws -> UserDefaults {
        let name = "aggielink.tests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: name))
        defaults.removePersistentDomain(forName: name)
        return defaults
    }
}
