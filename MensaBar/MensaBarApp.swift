//
//  MensaBarApp.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 23.05.25.
//

import SwiftUI

@main
struct MensaBarApp: App {

    var body: some Scene {
        MenuBarExtra(
            "Menu Bar Example",
            systemImage: "fork.knife"
        ) {
            ContentView(vm: MenuViewModel())
        }.menuBarExtraStyle(.window)
    }
}
