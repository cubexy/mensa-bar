//
//  SettingsMenuView.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 01.06.25.
//

import SwiftUI

struct SettingsMenuView: View {
    var openOnGithub: () -> Void
    var exit: () -> Void
    
    var body: some View {
        Menu {
            Button("Auf GitHub öffnen", action: openOnGithub)
            Divider()
            Button("Schließen", action: exit).keyboardShortcut("q", modifiers: .command)
        } label: {
            Image(systemName: "gear")
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .menuIndicator(.hidden)
        .fixedSize()
    }
}
