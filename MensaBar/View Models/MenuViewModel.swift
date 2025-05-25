//
//  MenuViewModel.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 25.05.25.
//

import Foundation

@MainActor
class MenuViewModel: ObservableObject {
    @Published var menu: [MenuItemViewModel] = []
    
    func populateMenu() async {
        do {
            let menu = try await WebService().getMensaMeals()
            self.menu = menu.map { MenuItemViewModel($0) }
        } catch {
            print("Error fetching menu: \(error)")
        }
    }
}

struct MenuItemViewModel {
    
    private var item: MenuItem
    
    init(_ item: MenuItem) {
        self.item = item
    }
    
    var name: String {
        item.name
    }
    
    var description: String! {
        item.description
    }
    
    var price: String {
        String(format: "%.2f €", item.price)
    }
    
}
