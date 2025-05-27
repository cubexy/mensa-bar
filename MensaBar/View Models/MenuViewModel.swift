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

    /**
    Initial menu population.
     */
    func populateMenu() async {
        do {
            let date = DatePickerService.getDate()
            let url = MensaUrlService.getMensaUrl(
                date: date,
                options: [.init(variable: "location", option: "106")]
            )
            let menu = try await WebService.getMensaMeals(url: url)
            self.menu = menu.map { MenuItemViewModel($0) }
        } catch {
            print("Error fetching menu: \(error)")
        }
    }
}

struct CafeteriaMenuViewModel {
    private var menu: [MenuItemViewModel]
    private var date: Date

    init(menuItems: [MenuItemViewModel], date: Date) {
        self.menu = menuItems
        self.date = date
    }
}

struct MenuItemViewModel {
    private var item: MenuItem

    init(_ item: MenuItem) {
        self.item = item
    }

    var id: Int {
        item.id
    }

    var name: String {
        item.name
    }

    var description: String? {
        item.description
    }

    var price: String {
        String(format: "%.2f €", item.price)
    }
}
