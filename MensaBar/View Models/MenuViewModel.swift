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
    @Published var cafeteriaId: String?
    @Published var cafeteriaSelection: String = "106"

    /**
    Exit the app.
     */
    func exit() {
        NSApplication.shared.terminate(nil)
    }

    /**
    Display the GitHub page of the project.
     */
    func openOnGithub() {
        let BASE_URL = Constants.Urls.repositoryBaseUrl
        NSWorkspace.shared.open(BASE_URL)
    }
    
    /**
    Fetch all displayable cafeterias. (TODO: Only show cafeterias that have food during the certain day.)
     */
    func getCafeterias() -> [UrlVariableOption] {
        return Variables.urlVariables["location"] ?? []
    }
    
    /**
    Change the cafeteria.
     */
    func setCafeteria(_ cafeteriaId: String) async {
        self.cafeteriaSelection = cafeteriaId
        self.menu = nil
        await self.populateMenu()
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
                options: [.init(variable: "location", option: cafeteriaSelection)]
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
        if self.menuDate == nil {
            // no menudate was set yet
            return DatePickerService.getDate()
        }

        if self.menu == nil {
            // menudate was manually set and menu was reset
            return self.menuDate!
        }

        let wasUpdatedRecently =
            Date().timeIntervalSince(self.menu!.updatedAtTimestamp)
            < Variables.Options.recentlyUpdatedTriggerTime

        if !wasUpdatedRecently {
            // menu is being updated, was last updated some time ago
            return DatePickerService.getDate()
        }

        // menu is being updated, was updated recently
        return self.menuDate!
    }
}

struct CafeteriaMenuViewModel {
    var menu: [MenuItemViewModel]
    var updatedAtTimestamp: Date
    var loading: Bool = true

    init(menuItems: [MenuItemViewModel], date: Date) {
        self.menu = menuItems
        self.updatedAtTimestamp = date
    }

    func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        let formattedDate = dateFormatter.string(from: self.updatedAtTimestamp)
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
