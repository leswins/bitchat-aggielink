//
// AppRuntimeHost.swift
// bitchat
//
// Holds AppRuntime so a first launch can finish onboarding before Bluetooth
// starts. Returning users create the runtime immediately, which keeps
// Bluetooth state restoration on the same schedule as upstream.
//

import SwiftUI

@MainActor
final class AppRuntimeHost: ObservableObject {
    @Published private(set) var runtime: AppRuntime?

    init(startImmediately: Bool) {
        if startImmediately {
            runtime = AppRuntime()
        }
    }

    func startIfNeeded() {
        if runtime == nil {
            runtime = AppRuntime()
        }
        runtime?.start()
    }
}
