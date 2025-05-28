//
//  MenuViewModel.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 25.05.25.
//

import Foundation

@MainActor
class MenuViewModel: ObservableObject {
    @Published var menu: CafeteriaMenuViewModel?
    @Published var loading: Bool = true
    @Published var error: String?

    /**
    Initial menu population.
     */
    func populateMenu() async {
        self.loading = true
        self.error = nil
        do {
            let date = DatePickerService.getDate()
            let url = MensaUrlService.getMensaUrl(
                date: date,
                options: [.init(variable: "location", option: "106")]
            )
            let menu = try await WebService.getMensaMeals(url: url)
            let vmItems = menu.map { MenuItemViewModel($0) }
            self.menu = CafeteriaMenuViewModel(menuItems: vmItems, date: date)
        } catch RecipeFetchError.noResponse {
            self.error = "Fehler beim Erhalten der Daten. Bitte überprüfe deine Internetverbindung."
        } catch RecipeFetchError.invalidResponse {
            self.error = "Fehler beim Abrufen der Daten."
        } catch RecipeFetchError.parsingFailed {
            self.error = "Fehler beim Verarbeiten der Daten."
        } catch {
            self.error = "Ein unerwarteter Fehler ist aufgetreten."
        }
        self.loading = false

    }

    func setDate(_ date: Date) {
        return
    }
}

struct CafeteriaMenuViewModel {
    var menu: [MenuItemViewModel]
    private var date: Date
    var loading: Bool = true

    init(menuItems: [MenuItemViewModel], date: Date) {
        self.menu = menuItems
        self.date = date
    }

    func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.string(from: date)
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
