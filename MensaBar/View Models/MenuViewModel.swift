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
    @Published var error: ErrorViewModel?
    var date: Date?

    /**
    Initial menu population.
     */
    func populateMenu() async {
        self.loading = true
        self.error = nil
        var selectedDate: Date?
        do {
            selectedDate = self.date == nil ? try DatePickerService.getDate() : self.date
        } catch let error {
            self.error = ErrorViewModel(errorTitle: "unknown date picking error", errorMessage: "unhandled date picking error - error: \(error.localizedDescription)", errorDisplayTitle: "Unerwarteter Fehler", errorDisplayMessage: "Ein unerwarteter Fehler ist aufgetreten.", errorDate: nil)
        }
        
        do {
            let url = MensaUrlService.getMensaUrl(
                date: selectedDate!,
                options: [.init(variable: "location", option: "106")]
            )
            let menu = try await WebService.getMensaMeals(url: url)
            let vmItems = menu.map { MenuItemViewModel($0) }
            self.menu = CafeteriaMenuViewModel(menuItems: vmItems, date: Date())
            self.date = selectedDate!
        } catch RecipeFetchError.noResponse {
            self.error = ErrorViewModel(errorTitle: "connection failed", errorMessage: "could not get response from server", errorDisplayTitle: "Verbindung fehlgeschlagen", errorDisplayMessage: "Fehler beim Erhalten der Daten. Bitte überprüfe deine Internetverbindung.", errorDate: selectedDate)
        } catch RecipeFetchError.invalidResponse {
            self.error = ErrorViewModel(errorTitle: "invalid response", errorMessage: "server returned invalid (empty) response", errorDisplayTitle: "Abruf der Daten  fehlgeschlagen", errorDisplayMessage: "Fehler beim Abrufen der Daten.", errorDate: selectedDate)
        } catch RecipeFetchError.parsingFailed(let errorDispatch, let mealData) {
            self.error = ErrorViewModel(errorTitle: errorDispatch.rawValue, errorMessage: mealData, errorDisplayTitle: "Verarbeitungsfehler", errorDisplayMessage: "Verarbeiten der Daten fehlgeschlagen.", errorDate: selectedDate)
        } catch let error {
            self.error = ErrorViewModel(errorTitle: "unknown general error", errorMessage: "unhandled general error - error: \(error.localizedDescription)", errorDisplayTitle: "Unerwarteter Fehler", errorDisplayMessage: "Ein unerwarteter Fehler ist aufgetreten.", errorDate: selectedDate)
        }
        self.loading = false

    }

    func setDate(_ date: Date) async {
        self.date = date
        self.menu = nil
        await self.populateMenu()
    }
}

struct ErrorViewModel {
    var errorDate: Date?
    var errorTitle: String
    var errorMessage: String
    var errorDisplayTitle: String
    var errorDisplayMessage: String
    
    init(errorTitle: String, errorMessage: String, errorDisplayTitle: String, errorDisplayMessage: String, errorDate: Date?) {
        self.errorTitle = errorTitle
        self.errorDisplayTitle = errorDisplayTitle
        self.errorMessage = errorMessage
        self.errorDisplayMessage = errorDisplayMessage
        self.errorDate = errorDate
    }
    
    private func getIssueTitle() -> String {
        return "[BUG] error: " + self.errorTitle
    }
    
    private func getIssueBody() -> String {
        return """
**Error code**
\(self.errorMessage)

**Menu date**
\(self.errorDate != nil ? getTimestampString(date: self.errorDate!, includeTime: false) : "N/A")

**Additional information**
Add additional information here.
"""
    }
    
    func getErrorIssueUrl() -> URL {
        let REPO_URL = Constants.Urls.repositoryBaseUrl
        
        var urlComponents = URLComponents(
            url: REPO_URL,
            resolvingAgainstBaseURL: true
        )!
        let queryItems = [
            URLQueryItem(name: "title", value: getIssueTitle()),
            URLQueryItem(name: "body", value: getIssueBody()),
            URLQueryItem(name: "labels", value: "bug")
        ]
        urlComponents.queryItems = queryItems
        return urlComponents.url ?? REPO_URL
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
        return getTimestampString(date: self.date)
    }
}

private func getTimestampString(date: Date, includeTime: Bool = true) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = includeTime ? "dd.MM.yyyy, HH:mm" : "dd.MM.yyyy"
    return dateFormatter.string(from: date)
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
