//
//  MenuViewModel.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 25.05.25.
//

import AppKit
import Foundation

@MainActor
class MenuViewModel: ObservableObject {
    @Published var menu: CafeteriaMenuViewModel?
    @Published var loading: Bool = true
    @Published var error: ErrorViewModel?
    @Published var menuDate: Date?

    func exit() {
        NSApplication.shared.terminate(nil)
    }

    func openOnGithub() {
        let BASE_URL = Constants.Urls.repositoryBaseUrl
        NSWorkspace.shared.open(BASE_URL)
    }

    /**
    Initial menu population.
     */
    func populateMenu() async {
        self.loading = true
        self.error = nil
        let selectedDate = self.getDate()
        do {
            let url = MensaUrlService.getMensaUrl(
                date: selectedDate,
                options: [.init(variable: "location", option: "106")]
            )
            let menu = try await WebService.getMensaMeals(url: url)
            let vmItems = menu.map { MenuItemViewModel($0) }
            self.menu = CafeteriaMenuViewModel(menuItems: vmItems, date: Date())
            self.menuDate = selectedDate
        } catch RecipeFetchError.noResponse {
            self.error = ErrorViewModel(
                errorTitle: "connection failed",
                errorMessage: "could not get response from server",
                errorDisplayTitle: "Verbindungsfehler",
                errorDisplayMessage:
                    "Fehler beim Abrufen der Daten. Bitte überprüfe die Verbindung.",
                errorDate: selectedDate,
                canReport: false
            )
        } catch RecipeFetchError.invalidResponse {
            self.error = ErrorViewModel(
                errorTitle: "invalid response",
                errorMessage: "server returned invalid (empty) response",
                errorDisplayTitle: "Verbindungsfehler",
                errorDisplayMessage: "Fehler beim Erhalten der Daten.",
                errorDate: selectedDate,
                canReport: false
            )
        } catch RecipeFetchError.parsingFailed(let errorDispatch, let mealData)
        {
            self.error = ErrorViewModel(
                errorTitle: errorDispatch.rawValue,
                errorMessage: mealData,
                errorDisplayTitle: "Verarbeitungsfehler",
                errorDisplayMessage: "Verarbeiten der Daten fehlgeschlagen.",
                errorDate: selectedDate
            )
        } catch let error {
            self.error = ErrorViewModel(
                errorTitle: "unknown general error",
                errorMessage:
                    "unhandled general error - error: \(error.localizedDescription)",
                errorDisplayTitle: "Unerwarteter Fehler",
                errorDisplayMessage: "Ein unerwarteter Fehler ist aufgetreten.",
                errorDate: selectedDate
            )
        }
        self.loading = false
    }

    func setDate(_ date: Date) async {
        self.menuDate = date
        self.menu = nil
        await self.populateMenu()
    }

    private func getDate() -> Date {
        if self.menuDate == nil || self.menu == nil {
            return DatePickerService.getDate()
        }

        let wasUpdatedRecently =
            Date().timeIntervalSince(self.menu!.date)
            < Variables.Options.recentlyUpdatedTriggerTime

        if !wasUpdatedRecently {
            return DatePickerService.getDate()
        }

        return self.menuDate!
    }
}

struct CafeteriaMenuViewModel {
    var menu: [MenuItemViewModel]
    var date: Date
    var loading: Bool = true

    init(menuItems: [MenuItemViewModel], date: Date) {
        self.menu = menuItems
        self.date = date
    }

    func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        let formattedDate = dateFormatter.string(from: self.date)
        return "Zuletzt aktualisiert: \(formattedDate)"
    }
}

struct MenuItemViewModel {
    private var item: MenuItem

    init(_ item: MenuItem) {
        self.item = item
    }

    var id: Int { item.id }

    var name: String { item.name }

    var description: String? { item.description }

    var price: String {
        String(format: "%.2f €", item.price)
    }
}
