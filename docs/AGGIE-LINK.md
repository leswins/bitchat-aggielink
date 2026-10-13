# Aggie Link

Aggie Link is a homecoming build of the public-domain [bitchat](https://github.com/permissionlesstech/bitchat) Bluetooth mesh. It is an independent project for the Aggie community. It is not an official North Carolina A&T State University app.

The mesh, packet format, Noise identity, and service UUIDs are unchanged. Topics are hashtags inside the existing public message body, so a bitchat iOS or Android peer still sees an ordinary message.

## Fork base

- Repository: `leswins/bitchat-aggielink`
- Base commit: `5e9287f` (2026-09-24), identical to `permissionlesstech/bitchat` main at the time of the fork
- Do not merge upstream again before the end of GHOE (November 1, 2026)
- New product code lives in `bitchat/AggieLink/`
- Upstream files change only at `AggieLinkConfig` seams
- Module name stays `bitchat`. Display name is Aggie Link. URL scheme stays `bitchat`

## What this build turns off

`AggieLinkConfig` hides voice, photos, payments, notices, QR verification, location channels, Tor, Nostr, and the bridge. A fresh install does not prompt for location and does not open a network connection for messaging. `GeoRelayDirectory` prefetch is skipped while internet transports are off.

Public topic messages are signed cleartext. Anyone nearby can read them. Private messages stay Noise-encrypted. A nickname is not a verified identity.

## Replace before a public build

| Placeholder | File | Replace with |
| --- | --- | --- |
| Empty `DEVELOPMENT_TEAM` | `Configs/Release.xcconfig` | Apple Developer Team ID. Archive reads this file. `Configs/Local.xcconfig` is Debug-only. |
| `https://testflight.apple.com` | `AggieLinkConfig.shareURL` | Live external TestFlight link, then the App Store URL |
| `support@aggielink.app` | `AggieLinkConfig.supportEmail` | A monitored mailbox |
| Placeholder icon | `bitchat/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png` and `AppIconDebug.appiconset/image-1024.png` | Final original artwork. Do not use a university wordmark or logo. |

`ITSAppUsesNonExemptEncryption` is already `true`. Do not invent an export-compliance code. Answer the App Store Connect questionnaire once, then you may add `ITSEncryptionExportComplianceCode`.

Bundle id `com.aggielink.ios` and app group `group.com.aggielink.ios` cannot change after the first TestFlight upload. Bump `CURRENT_PROJECT_VERSION` in `Configs/Release.xcconfig` for every later upload. Marketing version is `1.0.0`.

## Debug versus Release

The Bluetooth service UUID is testnet in Debug and mainnet in Release:

- Debug: `F47B5E2D-4A9E-4C5A-9B3F-8E1D2C3A4B5A`
- Release / TestFlight / App Store bitchat: `F47B5E2D-4A9E-4C5A-9B3F-8E1D2C3A4B5C`

Phones only see other phones on the same UUID. Every field tester must install the same TestFlight (Release) build. A Debug install from Xcode cannot see a TestFlight phone. If Xcode direct install is the only option, every test phone must be a Debug build.

`SecureLogger` is compiled out of Release. TestFlight builds do not write a log file. Diagnostics that still work are `/ping`, `/trace`, the topology map in App Info, and TestFlight crash reports.

## Install

1. Confirm an active Apple Developer Program membership and install Xcode 26.x (`LastUpgradeCheck` 2650).
2. Create the App Store Connect app for `com.aggielink.ios`. Limit availability to the United States.
3. Put the Team ID in `Configs/Release.xcconfig`.
4. Enable GitHub Actions on this fork. Unsigned CI is `ios-build` in `.github/workflows/swift-tests.yml` (`CODE_SIGNING_ALLOWED=NO`).
5. Open `bitchat.xcodeproj`, scheme **bitchat (iOS)**, run destination Any iOS Device, Product → Archive (Release).
6. Upload the archive. Answer export compliance: the app uses standard encryption (Noise and secp256k1) and is not exempt. Skip the France declaration by staying US-only.
7. Add the ten testers as internal testers (App Store Connect users on the team). Internal TestFlight does not wait for Beta App Review.
8. Submit the same build to an external group so Beta App Review can start. That public link is the contingency if App Review slips past October 25.
9. Send testers the install steps below.

Tester install:

1. Accept the TestFlight email on the phone you will carry.
2. Choose a nickname people will recognize. It does not prove identity.
3. Allow Bluetooth when iOS asks.
4. Turn Airplane Mode on, then turn Bluetooth back on. Airplane Mode switches Bluetooth off.
5. Keep Aggie Link open during a test unless the script says to background it.
6. Record iPhone model and iOS version on the shared results sheet. Fill the sheet offline and sync later.

## Field test

Everyone is on the same TestFlight build. Use real-name-ish nicknames. One shared results sheet.

**Test 1 — basic.** Same room. Each person sends `hi from <name>` in All and in `#Tailgates`. Everyone should receive all 20 messages. The people-count in the header equals N−1. Run `/who`.

**Test 2 — multi-hop.** Line A—B—C—D with about 20–30 m and walls between non-adjacent phones. In the topology map, A should not see C or D as a direct link. From A, `/ping @D` (expect hops of at least 2) and `/trace @D`. Send 10 messages A→D and 10 D→A. Record successes, stopwatch latency, and hop counts. Repeat with 5 relays if the space allows.

**Test 3 — background and lock.** Repeat Test 2 with relay B (a) backgrounded, (b) locked in a pocket, (c) locked for 10+ minutes, (d) force-quit, which should fail. Record which setups still relay. For wake-on-proximity, D walks away for 5 minutes and comes back.

**Test 4 — churn.** Two people walk out of range and back. Time how long the header count and delivery take to recover. One person force-quits and relaunches mid-test. Recent public history should return (gossip archive up to 6 hours).

**Test 5 — interop.** One phone on App Store bitchat for iOS and, if available, one on bitchat Android v2.0.1. Airplane Mode on those phones too. Public messages (including `#` tags) and private messages should move both ways. bitchat shows every topic in one timeline. This result is a hypothesis, not a launch blocker.

**Test 6 — onboarding.** Three people install from the TestFlight invite with no help. Time them to the first message and write down every confusion.

Also record battery percent per hour in the foreground, crashes (TestFlight Crashes and Xcode Organizer), and whether a nickname collision shows the `#xxxx` suffix.

Any message that arrives in Airplane Mode with internet transports off is Bluetooth. On a bitchat phone, Airplane Mode also closes Nostr and bridge paths.

Launch-blocking failures:

- Crash on launch or during onboarding
- Test 1 delivery under 90%
- Zero of ten two-hop deliveries
- No rediscovery within 2 minutes of returning to range
- A status that says the mesh is fine while Bluetooth is off or denied
- A private message readable outside that private chat

Document, but do not block launch: slower relay while locked or backgrounded, multi-hop delays over 30 seconds, history lost on force-quit beyond the 6-hour archive, no delivery receipts on topic messages, unverified nicknames.

## App Store

Capture screenshots on the iPhone sizes App Store Connect marks required (the 6.9-inch display, and the 6.5-inch display if it still asks):

1. Welcome screen
2. Nickname and Turn on Bluetooth
3. Empty mesh, searching line, topic chips
4. A `#Tailgates` thread with the mesh status line showing a direct-connection count
5. A private conversation
6. App Info, including the report email

Metadata you can paste:

- Name: Aggie Link
- Subtitle: Nearby messages without signal
- Promotional text: Message people around you when the network is crowded. Homecoming 2026.
- Keywords: mesh,bluetooth,offline,homecoming,aggie,nearby,chat
- Description: Aggie Link sends messages from phone to phone over Bluetooth. It keeps working when cellular service is crowded. There is no account and no server. Public topics are readable by people nearby. Private messages are encrypted. Delivery is not guaranteed, and Aggie Link is not for emergencies. Aggie Link is an independent project. It is not an official North Carolina A&T State University app.
- Support URL: a page you control, or a `mailto:` you have confirmed App Store Connect accepts
- Marketing URL: optional

Privacy nutrition label: Data Not Collected. No tracking. No account. Do not declare location, contacts, or photos. Bluetooth is required for the app to function and is not used to build an advertising profile.

Age rating: match the live bitchat listing, and expect 17+ because public messages are unmoderated. User-generated content is yes. Unrestricted web access is no. People can block from a long-press, and they can report to the support email named in onboarding and App Info.

Review notes:

> Aggie Link is a Bluetooth mesh messenger for a campus homecoming (GHOE 100, October 25–November 1, 2026). It needs two physical iPhones with Bluetooth on. It does not use an account or a server. Please watch the attached 60–90 second video: onboarding, a public message in #Tailgates, the mesh status line, and a private message.
>
> Differences from bitchat, whose public-domain protocol this app uses: first-launch onboarding, four homecoming topics filtered on the phone, a mesh status line that separates direct links from people reached through other phones, and a smaller feature set (no location channels, internet relay, voice, photos, or payments). The Bluetooth protocol is unchanged, so the app can exchange messages with bitchat.
>
> Moderation: press and hold a name to block. Abuse reports go to the support address in App Info. Onboarding states that a nickname is not a verified identity and that public messages are readable nearby.

Video script, 60–90 seconds, two phones side by side: finish onboarding on phone B, send in `#Tailgates` from phone A, show the message and the “nearby connection” line on B, open a private chat and show that the public timeline does not contain it.

Expedited review request:

> Please expedite review. Aggie Link is a free offline messenger for a scheduled campus gathering, GHOE 100 at North Carolina A&T, October 25–November 1, 2026 (game day October 31). Cellular service at the event is expected to be unusable. The app collects no account data and uses no server.

If the App Store is not approved in time, publish the external TestFlight link. Last resort: a page that tells people to install bitchat and use `#Aggieland` and `#Tailgates`. That works because the protocol and the Release UUID are shared.

## Strings

`scripts/strip-localizations-to-english.py` keeps the English column of both string catalogs, renames visible “bitchat” copy to Aggie Link, and removes `/pay` and `/drop` from `/help`. The `bitchat://` scheme is preserved. Re-run the script after adding catalog strings. New Aggie Link screens use `Text(verbatim:)` so they do not need catalog keys.

## Touched files

Product code: `bitchat/AggieLink/` (`AggieLinkConfig`, onboarding, topics, mesh status, invite text, runtime host).

Seams: `BitchatApp.swift`, `Theme.swift`, `PublicChatModel.swift`, `ContentView.swift`, `ContentHeaderView.swift`, `ContentComposerView.swift`, `ContentSheetViews.swift`, `TextMessageView.swift`, `AppInfoView.swift`, `MeshEmptyStateView.swift`, `NetworkActivationService.swift`, `AppRuntime.swift`, `CommandInfo.swift`, `ChannelShare.swift`, `PrivacyScreen.swift`, `NotificationService.swift`, `LocationChannelsSheet.swift`, `PanicWipeBlockedBanner.swift`, `bitchatShareExtension/ShareViewController.swift`.

Config and assets: `Configs/Release.xcconfig`, `Configs/Local.xcconfig.example`, `bitchat/Info.plist`, `bitchatShareExtension/Info.plist`, `bitchat.xcodeproj/project.pbxproj` (display name only), `LaunchScreen.storyboard`, accent color, app icons.

Copy and tests: both `Localizable.xcstrings` catalogs, `LocalizationCoverageTests.swift`, `AggieTopicTests.swift`, `AggieLinkOnboardingTests.swift`, `scripts/strip-localizations-to-english.py`.
