//
//  MensaUrlService.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 26.05.25.
//

import Foundation

class MensaUrlService {
    static func getMensaUrl(date: Date, options: [UrlVariableSelection]?) -> URL
    {
        let BASE_URL = Constants.Urls.mensaBaseUrl
        let DATE_FORMAT = Constants.UrlVariables.dateFormat
        let DATE_VARIABLE_NAME = Constants.UrlVariables.dateVariableName

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        let dateString = dateFormatter.string(from: date)

        var urlComponents = URLComponents(
            url: BASE_URL,
            resolvingAgainstBaseURL: true
        )!
        var queryItems: [URLQueryItem] = []

        queryItems.append(
            URLQueryItem(name: DATE_VARIABLE_NAME, value: dateString)
        )

        for option in options ?? [] {
            queryItems.append(
                URLQueryItem(name: option.variable, value: option.option)
            )
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url ?? BASE_URL
    }
}
