//
//  ContentView.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 23.05.25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm: MenuViewModel
    
    init(vm: MenuViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Speiseplan heute (Mensa am Park)").fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 10)
            List(vm.menu, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text(item.name).fontWeight(.semibold)
                    if item.description != nil {
                        Text(item.description ?? "")
                    }
                    Text(item.price)
                }
            }.task {
                await vm.populateMenu()
            }
        }.frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView(vm: MenuViewModel())
}
