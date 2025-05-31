//
//  ContentNotFoundView.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 29.05.25.
//

import SwiftUI

struct ContentNotFoundView: View {
    let error: String?
    let systemImage: String
    let errorTitle: String
    
    var body: some View {
        ContentUnavailableView {
            Label(
                errorTitle,
                systemImage: systemImage
            )
        } description: {
            Text(
                error
                    ?? "Die Gerichte konnten nicht geladen werden. Bitte versuche es später erneut."
            ).foregroundStyle(.primary).colorMultiply(.secondary)
        }
    }
}
