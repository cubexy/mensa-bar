//
//  ContentView.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 23.05.25.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var vm: MenuViewModel
    @State private var date = Date.now
    @State private var isShowingPopover = false

    init(vm: MenuViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        let menu = vm.menu
        let loading = vm.loading
        let error = vm.error
        VStack(alignment: .leading) {
            Text("Speiseplan (Mensa am Park)").fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 10)
            DatePicker(
                "am",
                selection: $date,
                displayedComponents: [.date]
            ).padding(.horizontal).datePickerStyle(.compact).environment(
                \.locale,
                Locale.init(identifier: "de")
            ).onChange(of: date) {
                Task {
                    await vm.setDate(date)
                }
            }
            if menu == nil {
                // was not able to load entries
                Spacer()
                if vm.loading {
                    HStack(alignment: .center) {
                        Spacer()
                        ProgressView("Speiseplan wird geladen")
                        Spacer()
                    }.transition(.blurReplace)
                } else {
                    ContentNotFoundView(
                        error: error,
                        systemImage: "exclamationmark.triangle.fill",
                        errorTitle: "Fehler beim Laden"
                    ).transition(.blurReplace)
                }
                Spacer()
            } else if menu!.menu.isEmpty {
                // no entries for selected day (weekend, ...)
                Spacer()
                ContentNotFoundView(
                    error:
                        "Für den ausgewählten Tag werden keine Gerichte angeboten.",
                    systemImage: "menucard",
                    errorTitle: "Keine Gerichte"
                ).transition(.blurReplace)
                LastUpdatedView(
                    loading: loading,
                    error: error,
                    isShowingPopover: $isShowingPopover,
                    timestamp: menu!.getTimestamp()
                ).padding(.horizontal)
                .transition(.blurReplace)
                Spacer()
            } else {
                List {
                    ForEach(menu!.menu, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text(item.name).fontWeight(.semibold)
                            if let description = item.description,
                                !description.isEmpty
                            {
                                Text(description).foregroundStyle(
                                    .secondary
                                )
                            }
                            Text(item.price)
                        }
                    }
                    LastUpdatedView(
                        loading: loading,
                        error: error,
                        isShowingPopover: $isShowingPopover,
                        timestamp: menu!.getTimestamp()
                    ).listRowSeparator(.hidden)
                }.transition(.blurReplace)
            }
        }.task {
            await vm.populateMenu()
        }
        .frame(width: 300, height: 300)
        .animation(.bouncy, value: vm.loading)
    }
}

#Preview {
    ContentView(vm: MenuViewModel())
}
