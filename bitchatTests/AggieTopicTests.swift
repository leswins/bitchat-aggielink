//
// AggieTopicTests.swift
// bitchatTests
//

import Testing
@testable import bitchat

struct AggieTopicTests {
    @Test func allTopicMatchesEveryMessage() {
        #expect(AggieTopic.all.matches("hello"))
        #expect(AggieTopic.all.matches("#Tailgates later"))
    }

    @Test func hashtagMatchIsCaseInsensitiveAndWholeTag() {
        #expect(AggieTopic.tailgates.matches("meet at #Tailgates"))
        #expect(AggieTopic.tailgates.matches("#tailgates now"))
        #expect(AggieTopic.tailgates.matches("see you\n#TAILGATES"))
        #expect(!AggieTopic.tailgates.matches("plain tailgates"))
        #expect(!AggieTopic.tailgates.matches("#TailgatesExtra"))
        #expect(!AggieTopic.tailgates.matches("#Tail"))
        #expect(AggieTopic.findYourPeople.matches("come to #FindYourPeople"))
        #expect(!AggieTopic.findYourPeople.matches("#FindYour"))
    }

    @Test func outboundPrefixesOnlyTheSelectedTopic() {
        #expect(AggieTopic.outboundText("hello", selected: .all) == "hello")
        #expect(AggieTopic.outboundText("hello", selected: .theYard) == "#TheYard hello")
        #expect(AggieTopic.outboundText("#theYard hello", selected: .theYard) == "#theYard hello")
        #expect(AggieTopic.outboundText("already #Aggieland here", selected: .aggieland) == "already #Aggieland here")
    }
}
