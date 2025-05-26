//
//  MensaUrlService.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 26.05.25.
//

import Foundation

class MensaUrlService {
    func getMensaUrl(date: Date?, options: [UrlVariableSelection]?) -> URL {
        let calendar = Calendar.current
        let now = Date()
        
        let BASE_URL = Constants.Urls.mensaBaseUrl

        // Determine the selected date
        let selectedDate: Date
        if let explicitDate = date {
            selectedDate = explicitDate
        } else {
            let secondsSinceMidnight = calendar.component(.hour, from: now) * 3600 +
                                        calendar.component(.minute, from: now) * 60 +
                                        calendar.component(.second, from: now)
            if TimeInterval(secondsSinceMidnight) < Variables.Options.nextDayTriggerTime {
                // Current time is before the date offset, use today's date
                selectedDate = now
            } else {
                // Current time is past the date offset, use the next day's date
                selectedDate = calendar.date(byAdding: .day, value: 1, to: now) ?? now
            }
        }

        // Format the date for the URL (e.g., YYYY-MM-DD)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)

        // Create URL components to add query parameters
        var urlComponents = URLComponents(url: BASE_URL, resolvingAgainstBaseURL: true)!

        var queryItems: [URLQueryItem] = []

        // Add the date as a query parameter
        queryItems.append(URLQueryItem(name: "date", value: dateString))

        // Add options as query parameters
        for option in options ?? [] {
            queryItems.append(URLQueryItem(name: option.variable, value: option.option))
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url ?? BASE_URL // Return the constructed URL, or baseUrl as a fallback
    }
}
