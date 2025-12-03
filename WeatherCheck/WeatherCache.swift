//
//  WeatherCache.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 02/12/25.
//

import Foundation

final class WeatherCache {
    
    static let shared = WeatherCache()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let expiration: TimeInterval = 60 * 30 // 30 mins (optional)
    
    private struct CachedWeather: Codable {
        let timestamp: Date
        let data: WeatherDataModel
    }
    
    private func key(for identifier: String) -> String {
        return "weather_cache_" + identifier
    }
    
    func save(_ model: WeatherDataModel, for identifier: String) {
        let wrapper = CachedWeather(timestamp: Date(), data: model)
        do {
            let data = try JSONEncoder().encode(wrapper)
            defaults.set(data, forKey: key(for: identifier))
        } catch {
            print("❌ Failed to encode weather cache:", error)
        }
    }
    
    func load(for identifier: String, allowExpired: Bool = true) -> WeatherDataModel? {
        guard let data = defaults.data(forKey: key(for: identifier)) else { return nil }
        
        do {
            let wrapper = try JSONDecoder().decode(CachedWeather.self, from: data)
            
            // if you want to ignore very old data:
            if !allowExpired {
                let age = Date().timeIntervalSince(wrapper.timestamp)
                if age > expiration {
                    return nil
                }
            }
            
            return wrapper.data
        } catch {
            print("❌ Failed to decode weather cache:", error)
            return nil
        }
    }
}
