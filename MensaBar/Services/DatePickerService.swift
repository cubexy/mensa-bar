//
//  DatePickerService.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 27.05.25.
//

import Foundation

class DatePickerService {
    static func getDate() -> Date {
        let NEXT_DAY_TRIGGER_TIME = Variables.Options.nextDayTriggerTime

        let calendar = Calendar.current
        let now = Date()

        let selectedDate: Date
        let secondsSinceMidnight =
            calendar.component(.hour, from: now) * 3600
            + calendar.component(.minute, from: now) * 60
            + calendar.component(.second, from: now)
        if TimeInterval(secondsSinceMidnight) < NEXT_DAY_TRIGGER_TIME {
            selectedDate = now
        } else {
            selectedDate =
                calendar.date(byAdding: .day, value: 1, to: now) ?? now
        }

        return selectedDate
    }
}
