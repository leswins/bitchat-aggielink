//
// TopicBarView.swift
// bitchat
//

import SwiftUI

struct TopicBarView: View {
    @EnvironmentObject private var publicChatModel: PublicChatModel
    @ThemedPalette private var palette

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AggieTopic.allCases) { topic in
                    let selected = publicChatModel.selectedTopic == topic
                    Button {
                        publicChatModel.selectedTopic = topic
                    } label: {
                        Text(verbatim: topic.title)
                            .bitchatFont(size: 14, weight: selected ? .semibold : .regular)
                            .foregroundColor(selected ? palette.background : palette.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(selected ? palette.accent : palette.accent.opacity(0.12))
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selected ? .isSelected : [])
                    .accessibilityLabel(Text(verbatim: topic.title))
                    .accessibilityHint(Text(verbatim: "Shows messages in this topic"))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(verbatim: "Topics"))
    }
}
