//
//  ContentParsingFailedView.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 29.05.25.
//

import SwiftUI

struct ContentParsingFailedView: View {
    let error: ErrorViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ContentUnavailableView {
                Label(
                    error.errorDisplayTitle,
                    systemImage: "exclamationmark.triangle.fill"
                )
            } description: {
                Text(
                    error.errorDisplayMessage
                )
            }
            Link("Fehler melden", destination: error.getErrorIssueUrl())
            Spacer()
        }
        
    }
}
