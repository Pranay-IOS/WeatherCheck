//
//  Constants 2.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 03/12/25.
//
import UIKit

struct Constants {
    
    public static func formattedHour(from dateString: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return "-"
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Check if it's the current hour
        if calendar.component(.hour, from: date) == calendar.component(.hour, from: now)
            && calendar.isDate(date, inSameDayAs: now) {
            return "Now"
        }
        
        // Format normally
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h a"
        let formatted = outputFormatter.string(from: date).lowercased()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    
    public static func formattedForecastDateLabel(from apiDate: String) -> String {
        // 1. Parse the API date string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"      // API format
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = inputFormatter.date(from: apiDate) else {
            return apiDate   // fallback: return original string
        }

        let calendar = Calendar.current
        
        // 2. Day + short month, e.g. "3 Dec"
        let dayMonthFormatter = DateFormatter()
        dayMonthFormatter.dateFormat = "d MMM"
        dayMonthFormatter.locale = Locale.current
        let dayMonthString = dayMonthFormatter.string(from: date)
        
        // 3. Decide suffix: Today / Tomorrow / weekday (Fri, Sat, …)
        let suffix: String
        if calendar.isDateInToday(date) {
            suffix = "Today"
        } else if calendar.isDateInTomorrow(date) {
            suffix = "Tomorrow"
        } else {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEE"      // "Fri"
            weekdayFormatter.locale = Locale.current
            suffix = weekdayFormatter.string(from: date)
        }
        
        return "\(dayMonthString) \(suffix)"
    }
}
