//
//  LastUpdatedView.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 29.05.25.
//

import SwiftUI

struct LastUpdatedView: View {

    let loading: Bool
    let error: String?
    @Binding var isShowingPopover: Bool
    let timestamp: String

    var body: some View {
        HStack {
            if loading {
                ProgressView().scaleEffect(0.5).frame(
                    width: 8.0,
                    height: 8.0
                )
            } else if error != nil {
                Image(systemName: "exclamationmark.triangle")
                    .onHover(perform: { _ in
                        self.isShowingPopover = true
                    })
                    .popover(
                        isPresented: $isShowingPopover,
                        arrowEdge: .bottom
                    ) {
                        Text(error!).padding(8)
                    }
            }
            Text(
                "Zuletzt aktualisiert: \(timestamp)"
            )
            .listRowSeparator(.hidden)
            .foregroundStyle(.tertiary)

        }.padding(.horizontal).animation(
            .easeInOut(duration: 0.5),
            value: loading
        ).animation(
            .easeInOut(duration: 0.5),
            value: !loading && error != nil
        )

    }
}
