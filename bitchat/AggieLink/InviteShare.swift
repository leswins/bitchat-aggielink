//
// InviteShare.swift
// bitchat
//

import Foundation

enum InviteShare {
    static var text: String {
        """
        No signal? Stay connected with Aggie Link.

        \(AggieLinkConfig.shareURL)

        Everyone needs Aggie Link installed, open, with Bluetooth on. Messages travel from phone to phone and are not guaranteed to arrive.
        """
    }
}
