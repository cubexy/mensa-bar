//
//  WebService.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 23.05.25.
//

import Foundation
import SwiftSoup

enum RecipeFetchError: Error {
    case noResponse
    case invalidResponse
    case parsingFailed(errorDispatch: ErrorDispatch, mealData: String)
}

enum ErrorDispatch: String {
    case noMenuItems = "could not find menu items with class type--meal"
    case noTitle = "could not find title h4 element"
    case noPriceParent =
        "could not find price parent element with class meal-prices"
    case noPrice = "could not find student price child span element"
    case unknown = "unhandled error case"
}

class WebService {
    static func getMensaMeals(url: URL) async throws -> [MenuItem] {
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            throw RecipeFetchError.noResponse
        }

        guard let webData = String(data: data, encoding: .utf8) else {
            throw RecipeFetchError.invalidResponse
        }
        let document: Document = try SwiftSoup.parse(webData)
        let meals = try document.getElementsByClass("type--meal")
        if meals.size() == 0 {
            return []
        }
        let parsedMeals = try meals.enumerated().compactMap { (index, meal) in
            try parseMeal(meal, index)
        }
        return parsedMeals
    }

    static private func parseMeal(_ meal: Element, _ index: Int) throws
        -> MenuItem?
    {
        // parse meal title
        let titleElement = try meal.getElementsByTag("h4")
        guard titleElement.size() > 0 else {
            throw RecipeFetchError.parsingFailed(
                errorDispatch: ErrorDispatch.noTitle,
                mealData: try meal.html()
            )
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
            if titleText == "Samstagsangebot" { // issue #1 - "Samstagsangebot" modal is no valid food option
                return nil
            }
            throw RecipeFetchError.parsingFailed(
                errorDispatch: ErrorDispatch.noPriceParent,
                mealData: try meal.html()
            )
        }

        // we will only fetch the student's price :) if other prices are needed please open an issue on GitHub!
        let priceElement = try priceParentElement.get(0).getElementsByTag(
            "span"
        )
        guard priceElement.size() > 0 else {
            throw RecipeFetchError.parsingFailed(
                errorDispatch: ErrorDispatch.noPrice,
                mealData: try meal.html()
            )
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
