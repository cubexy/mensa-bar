//
//  WebService.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 23.05.25.
//

import Foundation
import SwiftSoup

enum RecipeFetchError: Error {
    case invalidResponse
    case parsingFailed
    case unexpected(message: String)
}

class WebService {
    static func getMensaMeals(url: URL) async throws -> [MenuItem] {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let webData = String(data: data, encoding: .utf8) else {
            throw RecipeFetchError.invalidResponse
        }
        let document: Document = try SwiftSoup.parse(webData)
        let meals = try document.getElementsByClass("type--meal")
        let parsedMeals = try meals.enumerated().map { (index, meal) in
            try parseMeal(meal, index)
        }
        return parsedMeals
    }

    static private func parseMeal(_ meal: Element, _ index: Int) throws
        -> MenuItem
    {
        // parse meal title
        let titleElement = try meal.getElementsByTag("h4")
        guard titleElement.size() > 0 else {
            throw RecipeFetchError.parsingFailed
        }
        let titleText: String = try titleElement.first()!.text().trim()

        // parse meal description
        let descriptionElement = try meal.getElementsByClass("meal-components")
        let descriptionText = try descriptionElement.first(where: {
            try !$0.text().trim().isEmpty
        })?.text().trim()

        // parse meal price
        let priceParentElement = try meal.getElementsByClass("meal-prices")
        guard priceParentElement.size() > 0 else {
            throw RecipeFetchError.parsingFailed
        }

        // we will only fetch the student's price :) if other prices are needed please open an issue on GitHub!
        let priceElement = try priceParentElement.get(0).getElementsByTag(
            "span"
        )
        guard priceElement.size() > 0 else {
            throw RecipeFetchError.parsingFailed
        }
        let priceText = try priceElement.first()!.text().trim()
            .replacingOccurrences(of: ",", with: ".").replacingOccurrences(
                of: " €",
                with: ""
            )
        let priceTextDouble = Double(priceText) ?? 0.0

        return MenuItem(
            id: index,
            name: titleText,
            description: descriptionText,
            price: priceTextDouble
        )
    }
}
