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
        let DATE_FORMAT = Constants.UrlVariables.dateFormat
        let NEXT_DAY_TRIGGER_TIME = Variables.Options.nextDayTriggerTime
        let DATE_VARIABLE_NAME = Constants.UrlVariables.dateVariableName

        let selectedDate: Date
        if let explicitDate = date {
            selectedDate = explicitDate
        } else {
            let secondsSinceMidnight = calendar.component(.hour, from: now) * 3600 +
                                        calendar.component(.minute, from: now) * 60 +
                                        calendar.component(.second, from: now)
            if TimeInterval(secondsSinceMidnight) < NEXT_DAY_TRIGGER_TIME {
                selectedDate = now
            } else {
                selectedDate = calendar.date(byAdding: .day, value: 1, to: now) ?? now
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        let dateString = dateFormatter.string(from: selectedDate)

        var urlComponents = URLComponents(url: BASE_URL, resolvingAgainstBaseURL: true)!
        var queryItems: [URLQueryItem] = []

        queryItems.append(URLQueryItem(name: DATE_VARIABLE_NAME, value: dateString))

        for option in options ?? [] {
            queryItems.append(URLQueryItem(name: option.variable, value: option.option))
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url ?? BASE_URL
    }
}
