//
//  Endpoints.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 01/12/25.
//

import UIKit

enum EndPoints {
    
    static let baseURL = "https://api.weatherapi.com/v1"
//    "https://api.openweathermap.org/data/2.5"
    static let weatherURL = "forecast.json" //"weather"
    static let hourlyForecastURL = "forecast/hourly"
    static let forecastURL = "forecast/daily"
}

enum AppConfig {
    static var apiKey: String {
        guard let value = Bundle.main.infoDictionary?["API_KEY"] as? String,
              value.isEmpty == false else {
            fatalError("❌ API_KEY is missing. Check your .xcconfig / Info.plist.")
        }
        return value
    }
}
