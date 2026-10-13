//
// AggieTopic.swift
// bitchat
//
// Client-side topics over the single public mesh timeline. A topic is a
// hashtag inside the existing UTF-8 public message, so other bitchat clients
// still see an ordinary message.
//

import Foundation

enum AggieTopic: String, CaseIterable, Identifiable, Equatable {
    case all
    case aggieland = "Aggieland"
    case theYard = "TheYard"
    case tailgates = "Tailgates"
    case findYourPeople = "FindYourPeople"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "All"
        default: return "#\(rawValue)"
        }
    }

    /// Hashtag token inserted into outgoing public messages, without '#'.
    var tag: String? {
        self == .all ? nil : rawValue
    }

    func matches(_ content: String) -> Bool {
        guard let tag else { return true }
        return Self.containsHashtag(tag, in: content)
    }

    func matching(_ messages: [BitchatMessage]) -> [BitchatMessage] {
        guard tag != nil else { return messages }
        return messages.filter { matches($0.content) }
    }

    /// Prefixes the selected topic tag when the text does not already contain it.
    static func outboundText(_ text: String, selected: AggieTopic) -> String {
        guard let tag = selected.tag else { return text }
        if containsHashtag(tag, in: text) { return text }
        return "#\(tag) \(text)"
    }

    /// True when `content` contains `#tag` as a whole hashtag, ignoring case.
    static func containsHashtag(_ tag: String, in content: String) -> Bool {
        let needle = "#" + tag.lowercased()
        let haystack = content.lowercased()
        var searchStart = haystack.startIndex
        while let range = haystack.range(of: needle, range: searchStart..<haystack.endIndex) {
            let after = range.upperBound
            let boundaryAfter = after == haystack.endIndex || !isTagCharacter(haystack[after])
            if boundaryAfter { return true }
            searchStart = after
        }
        return false
    }

    private static func isTagCharacter(_ character: Character) -> Bool {
        character.isLetter || character.isNumber || character == "_"
    }
}
