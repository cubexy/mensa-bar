//
//  SettingsMenuView.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 01.06.25.
//

import SwiftUI
import LaunchAtLogin

struct SettingsMenuView: View {
    var openOnGithub: () -> Void
    var exit: () -> Void
    
    var body: some View {
        Menu {
            LaunchAtLogin.Toggle("Bei Anmeldung öffnen")
            Button("Schließen", action: exit).keyboardShortcut("q", modifiers: .command)
            Divider()
            Button("GitHub", action: openOnGithub)
        } label: {
            Image(systemName: "gear")
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .menuIndicator(.hidden)
        .frame(width: 16, height: 16)
        .fixedSize()
    }
}
