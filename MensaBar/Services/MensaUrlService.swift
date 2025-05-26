//
//  MensaUrlService.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 26.05.25.
//

import Foundation

class MensaUrlService {
    let baseUrl: URL! = Constants.Urls.mensaBaseUrl
    
    func getMensaUrl(date: Date?, options: [UrlVariableSelection]) -> URL {
        return baseUrl
    }
}
