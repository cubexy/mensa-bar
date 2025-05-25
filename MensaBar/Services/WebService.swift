//
//  WebService.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 23.05.25.
//

import SwiftSoup
import Foundation

enum RecipeFetchError: Error {
    case invalidResponse
    case parsingFailed
    case unexpected(message: String)
}

class WebService {
    let dataUrl: URL! = Constants.Urls.mensaUrl

    func getMensaMeals() async throws -> [MenuItem] {
        let (data, _) = try await URLSession.shared.data(from: dataUrl)
        guard let webData = String(data: data, encoding: .utf8) else {
            throw RecipeFetchError.invalidResponse
        }
        let document: Document = try SwiftSoup.parse(webData)
        let meals = try document.getElementsByClass("type--meal")
        let parsedMeals = try meals.map { try parseMeal($0) }
        return parsedMeals
    }
    
    private func parseMeal(_ meal: Element) throws -> MenuItem {
        // parse meal title
        let titleElement = try meal.getElementsByTag("h4")
        guard titleElement.size() > 0 else { throw RecipeFetchError.parsingFailed }
        let titleText: String = try titleElement.get(0).text()
        
        // parse meal description
        let descriptionElement = try meal.getElementsByClass("meal-components")
        var descriptionText: String? = nil
        if descriptionElement.size() > 0 {
            descriptionText = try descriptionElement.get(0).text()
        }
        
        // parse meal price
        let priceParentElement = try meal.getElementsByClass("meal-prices")
        guard priceParentElement.size() > 0 else { throw RecipeFetchError.parsingFailed }
        
        // we will only fetch the student's price :) if other prices are needed please open an issue on GitHub!
        let priceElement = try priceParentElement.get(0).getElementsByTag("span")
        guard priceElement.size() > 0 else { throw RecipeFetchError.parsingFailed }
        let priceText = try priceElement.get(0).text().replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " €", with: "")
        let priceTextDouble = Double(priceText) ?? 0.0
    
        return MenuItem(name: titleText, description: descriptionText, price: priceTextDouble)
    }
}
