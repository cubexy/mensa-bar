//
//  Constants.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 25.05.25.
//

import Foundation

struct UrlVariableOption {
    var id: String
    var displayName: String
}

struct UrlVariable {
    var name: String
    var options: [UrlVariableOption]
}

struct Constants {
    struct Urls {
        static let mensaBaseUrl: URL = URL(string: "https://www.studentenwerk-leipzig.de/mensen-cafeterien/speiseplan/")!
    }
    struct UrlVariables {
        static let dateVariableName: String = "date"
        static let dateFormat: String = "yyyy-MM-dd"
    }
}

struct Variables {
    struct Options {
        static var nextDayTriggerTime: TimeInterval = 72000 // 20 * 60 * 60 == 20:00
    }
    static var urlVariables: [UrlVariable] = [
        .init(name: "location", options: [
            .init(id: "106", displayName: "Mensa am Park"),
            .init(id: "111", displayName: "Mensa Peterssteinweg"),
            .init(id: "115", displayName: "Mensa am Elsterbecken"),
            .init(id: "118", displayName: "Mensa Academica"),
            .init(id: "127", displayName: "Mensa am Botanischen Garten"),
            .init(id: "140", displayName: "Mensa Schönauer Straße"),
            .init(id: "153", displayName: "Cafeteria Dittrichring"),
            .init(id: "162", displayName: "Mensa am Medizincampus"),
            .init(id: "170", displayName: "Mensa An den Tierkliniken")
        ])
    ]
}
