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

struct UrlVariableSelection {
    var variable: String
    var option: String
}

struct Constants {
    struct Urls {
        static let mensaBaseUrl: URL = URL(
            string:
                "https://www.studentenwerk-leipzig.de/mensen-cafeterien/speiseplan/"
        )!
    }
    struct UrlVariables {
        static let dateVariableName: String = "date"
        static let dateFormat: String = "yyyy-MM-dd"
    }
}

struct Variables {
    struct Options {
        static var nextDayTriggerTime: TimeInterval = 72000  // 20 * 60 * 60 == 20:00
    }
    static var urlVariables: [String: [UrlVariableOption]] = [
        "location": [
            UrlVariableOption(id: "106", displayName: "Mensa am Park"),
            UrlVariableOption(id: "111", displayName: "Mensa Peterssteinweg"),
            UrlVariableOption(id: "115", displayName: "Mensa am Elsterbecken"),
            UrlVariableOption(id: "118", displayName: "Mensa Academica"),
            UrlVariableOption(
                id: "127",
                displayName: "Mensa am Botanischen Garten"
            ),
            UrlVariableOption(id: "140", displayName: "Mensa Schönauer Straße"),
            UrlVariableOption(id: "153", displayName: "Cafeteria Dittrichring"),
            UrlVariableOption(id: "162", displayName: "Mensa am Medizincampus"),
            UrlVariableOption(
                id: "170",
                displayName: "Mensa An den Tierkliniken"
            ),
        ]
    ]
}
