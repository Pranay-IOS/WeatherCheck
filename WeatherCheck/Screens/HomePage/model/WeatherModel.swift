//
//  WeatherModel.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 02/12/25.
//

import Foundation

// MARK: - WeatherDataModel
struct WeatherDataModel: Codable {
    let location: Location?
    let current: Current?
    let forecast: Forecast?
    let error: myError?
}

// MARK: - Current
struct Current: Codable {
    let lastUpdated: String?
    let tempC: Double?
    let isDay: Int?
    let condition: Condition?
    let windMph, windKph: Double?
    let pressureMB: Int?
    let pressureIn: Double?
    let humidity, uv: Int?

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case humidity, uv
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String?
    let icon: String?
    let code: Int
    
    var conditionName: String {
        switch code {
        case 1087:
            return "cloud.bolt"
        case 1150...1171:
            return "cloud.drizzle"
        case 1180...1201:
            return "cloud.rain"
        case 1213...1225:
            return "cloud.snow"
        case 1114...1147:
            return "cloud.fog"
        case 1000:
            return "sun.max"
        case 1273...1282:
            return "cloud.bolt"
        case 1114, 1117:
            return "wind.snow"
        case 1003, 1006, 1009:
            return "cloud"
        default:
            return "sun.max"
        }
    }
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]?
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String?
    let day: Day?
    let astro: Astro?
    let hour: [Hour]?
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise, sunset: String?
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, mintempC, avgtempC, maxwindMph: Double?
    let maxwindKph, totalsnowCM: Double?
    let dailyWillItRain, dailyChanceOfRain, dailyWillItSnow, dailyChanceOfSnow: Int?
    let condition: Condition?
    let uv: Double?

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalsnowCM = "totalsnow_cm"
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition, uv
    }
}

// MARK: - Hour
struct Hour: Codable {
    let time: String?
    let tempC: Double?
    let isDay: Int?
    let condition: Condition?
    let windKph: Double?
    let windDegree: Int?
    let windDir: String?
    let pressureIn, snowCM: Double?
    let humidity, cloud, willItRain, chanceOfRain: Int?
    let willItSnow, chanceOfSnow: Int?
    let uv: Double?

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureIn = "pressure_in"
        case snowCM = "snow_cm"
        case humidity, cloud
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
        case uv
    }
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String?
    let lat, lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

// MARK: - Error
struct myError: Codable {
    let code: Int?
    let message: String?
}
