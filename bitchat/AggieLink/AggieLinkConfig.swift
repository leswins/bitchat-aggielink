//
// AggieLinkConfig.swift
// bitchat
//
// Aggie Link product flags and copy. Upstream behavior stays in place behind
// these flags so the Bluetooth mesh, packet format, and identity model are
// unchanged.
//

import Foundation

enum AggieLinkConfig {
    static let displayName = "Aggie Link"
    static let tagline = "Stay connected in Aggieland."

    /// Public install link used by invites and location-channel shares.
    /// Replace with the live TestFlight public link or App Store URL before
    /// community rollout. See docs/AGGIE-LINK.md.
    static let shareURL = "https://testflight.apple.com"

    /// Support contact for abuse reports. Replace with a monitored address
    /// before public launch. See docs/AGGIE-LINK.md.
    static let supportEmail = "support@aggielink.app"

    static let internetTransportsEnabled = false
    static let voiceEnabled = false
    static let mediaEnabled = false
    static let paymentsEnabled = false
    static let locationChannelsEnabled = false
    static let noticesEnabled = false
    static let verificationUIEnabled = false
    static let showsThemePicker = false
    static let showsLanguagePicker = false
    static let topicsEnabled = true
    static let usesAggieAbout = true
    static let usesAggieEmptyState = true
    static let showsInviteButton = true
}

enum AggieLinkCopy {
    static let welcomeBody = "Aggie Link helps people nearby message each other when the cellular network is crowded. It is an independent project for the Aggie community. It is not an official North Carolina A&T State University app."
    static let occasion = "GHOE 100 · October 25 – November 1, 2026"
    static let howItWorksTitle = "How messages move"
    static let limits = [
        "Messages can travel through other phones running Aggie Link.",
        "More people nearby can create more paths.",
        "Bluetooth has to stay on. The app works best while it is open.",
        "A message can be delayed or never arrive. Aggie Link is not for emergencies.",
        "There is no phone number and no account. People nearby can read public messages. A nickname is not a verified identity."
    ]
    static let nicknamePrompt = "Choose a nickname"
    static let nicknameHint = "This is the name other people see. It does not prove who you are."
    static let acceptableUse = "Be respectful. Press and hold a name to block someone. To report abuse, email \(AggieLinkConfig.supportEmail)."
    static let bluetoothButton = "Turn on Bluetooth"
    static let bluetoothCaption = "iOS will ask for Bluetooth access next. Aggie Link needs it to find nearby phones."
    static let nicknameInvalid = "Use a nickname up to 50 characters, without line breaks."
    static let emptyStatePrimary = "Looking for nearby Aggies. Keep Bluetooth on and share Aggie Link with your friends to help grow the network."
    static let emptyStateSecondary = "Messages may be delayed or fail. Aggie Link does not replace phone service or emergency services."
    static let searching = "Searching for nearby Aggies…"
    static let panicNote = "Erases messages, keys, and identity on this phone. Triple-tapping the aggie/ mark does the same after you confirm."
    static let aboutHowTo = "Pick a topic, or stay in All. Type a message and send it. Open the people list to start a private conversation. Private messages are encrypted. Public topic messages are not."
    static let aboutLimits = "Delivery depends on who is nearby, whether their app is open, and Bluetooth conditions. A direct connection count is only the phones this one can hear, not everyone the mesh might reach."
    static let protocolCredit = "Messaging uses the public-domain bitchat protocol, so Aggie Link can talk with the bitchat apps."
    static let reportTitle = "Report abuse"
    static let inviteButton = "Invite friends"

    static func meshActive(direct: Int) -> String {
        direct == 1
            ? "Mesh active — 1 nearby connection"
            : "Mesh active — \(direct) nearby connections"
    }

    static func reachableThroughOthers(_ count: Int) -> String {
        count == 1
            ? "1 more reachable through other phones"
            : "\(count) more reachable through other phones"
    }

    static func reachableOnly(_ count: Int) -> String {
        count == 1
            ? "No direct link — 1 person reachable through other phones"
            : "No direct link — \(count) people reachable through other phones"
    }
}
