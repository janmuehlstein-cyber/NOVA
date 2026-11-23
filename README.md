# NOVA PULSE – iOS Apple Calendar Bridge

This folder contains the native iOS companion source required for direct Apple Calendar access. The public GitHub Pages PWA alone cannot access EventKit.

## What it does

- Uses Apple's EventKit with **full calendar access** (needed to read, create, update and delete existing events).
- Requests permission only after the user taps **Verbinden**.
- Reads events for the visible planning range and maps them into NOVA.
- Writes changes only after NOVA shows a separate confirmation dialog.
- Refreshes when the calendar view is opened or the user taps Synchronisieren.
- Keeps the EventKit bridge inside the iOS app; no iCloud password or calendar credentials are collected.

## Build requirement

A Mac with Xcode 15 or newer and an iPhone running iOS 17 or newer are required to compile and install this native component. The current Windows-only workflow can edit the files and publish the PWA, but cannot compile/sign an iOS app. The project source is supplied here for an Xcode build; it is not an IPA and is not yet installed on the phone.

## Create the Xcode target

1. On a Mac, open Xcode and create **iOS → App**, Product Name `NOVAPulse`, Interface `SwiftUI`, Language `Swift`.
2. Set deployment target to iOS 17.0 or newer.
3. Add `NOVAPulseApp.swift`, `CalendarWebView.swift`, and `AppleCalendarService.swift` to the app target (copy files into project).
4. Replace the generated Info.plist with this folder's `Info.plist`, or add the two calendar usage strings to the target's Info tab.
5. Add `EventKit.framework` and `WebKit.framework` if Xcode doesn't link them automatically.
6. Set a unique Bundle Identifier and select your own Apple Development signing team.
7. Build and run on the iPhone. On first use, open Settings in NOVA and tap **Verbinden**, then grant full calendar access.

The WebView is pinned to `https://janmuehlstein-cyber.github.io/NOVA/`. If the GitHub account/repository URL changes, update the URL and allowed host in `CalendarWebView.swift`.

## Consent model

The JavaScript UI asks for confirmation before every create, update or delete call. The native bridge only executes the operation sent after that explicit action. Full access is requested because read + update + delete are required; write-only permission cannot support the requested bidirectional sync.
