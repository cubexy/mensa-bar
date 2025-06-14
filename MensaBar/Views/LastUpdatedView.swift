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
            Text(
                timestamp
            )
            
            .foregroundStyle(.tertiary)
            .transition(.slide)
            Spacer()
            if loading {
                ProgressView().scaleEffect(0.5).frame(
                    width: 8.0,
                    height: 8.0
                ).transition(.opacity)
            } else if error != nil {
                Image(systemName: "exclamationmark.triangle")
                    .onHover(perform: { _ in
                        self.isShowingPopover = true
                    })
                    .transition(.opacity)
                    .popover(
                        isPresented: $isShowingPopover,
                        arrowEdge: .bottom
                    ) {
                        Text(error!).padding(8)
                    }
            }
        }.animation(
            .easeInOut,
            value: loading && error == nil
        )
    }
}
