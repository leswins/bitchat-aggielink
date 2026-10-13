//
// MeshStatusView.swift
// bitchat
//
// Direct connections and people reached through other phones are separate
// numbers. The header count stays the reachable total; this line says which
// part is a direct radio link.
//

import CoreBluetooth
import SwiftUI

struct MeshStatusView: View {
    @EnvironmentObject private var appChromeModel: AppChromeModel
    @EnvironmentObject private var peerListModel: PeerListModel
    @ThemedPalette private var palette

    var body: some View {
        if appChromeModel.bluetoothState == .poweredOn, let line = statusLine {
            Text(verbatim: line)
                .bitchatFont(size: 13, weight: .medium)
                .foregroundColor(palette.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .accessibilityLabel(Text(verbatim: line))
        }
    }

    private var statusLine: String? {
        let direct = peerListModel.connectedMeshPeerCount
        let reachable = peerListModel.reachableMeshPeerCount
        if direct > 0 {
            let extra = max(0, reachable - direct)
            if extra == 0 { return AggieLinkCopy.meshActive(direct: direct) }
            return AggieLinkCopy.meshActive(direct: direct) + " · " + AggieLinkCopy.reachableThroughOthers(extra)
        }
        if reachable > 0 {
            return AggieLinkCopy.reachableOnly(reachable)
        }
        return AggieLinkCopy.searching
    }
}
