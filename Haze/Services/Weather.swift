//
//  Weather.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//
import Foundation
import WeatherKit
import CoreLocation

let weatherService = WeatherService()

struct DayForecast {
    let label: String       // "MON", "TUE", …
    let iconName: String    // asset name from IconPack
    let high: Int           // °F
    let low: Int            // °F
}

struct WeatherData {
    let temp: Int
    let condition: AppWeatherCondition
    let windSpeed: Int
    let windDirection: WindDirection
    let forecast: [DayForecast]
}

func getWeather(for location: CLLocation) async throws -> WeatherData {
    let weather = try await weatherService.weather(for: location)
    let current = weather.currentWeather

    let tempF = current.temperature.converted(to: .fahrenheit)
    let temp = Int(tempF.value.rounded())

    let condition = AppWeatherCondition.from(current.condition)

    let speedMPH = current.wind.speed.converted(to: .milesPerHour)
    let windSpeed = Int(speedMPH.value.rounded())

    let windDirection = bearingToWindDirection(current.wind.direction.value)

    // Daily forecast: skip today (index 0), take the next 5 days
    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "EEE"  // Mon, Tue, …
    let forecast: [DayForecast] = weather.dailyForecast.forecast
        .dropFirst()
        .prefix(5)
        .map { day in
            let label    = dayFormatter.string(from: day.date).uppercased()
            let dayCondition = AppWeatherCondition.from(day.condition)
            let high     = Int(day.highTemperature.converted(to: .fahrenheit).value.rounded())
            let low      = Int(day.lowTemperature.converted(to: .fahrenheit).value.rounded())
            return DayForecast(label: label, iconName: dayCondition.weeklyIconName, high: high, low: low)
        }

    return WeatherData(temp: temp, condition: condition, windSpeed: windSpeed,
                       windDirection: windDirection, forecast: forecast)
}

func bearingToWindDirection(_ degrees: Double) -> WindDirection {
    switch degrees {
    case 337.5...360, 0..<22.5: return .north
    case 22.5..<67.5:           return .northEast
    case 67.5..<112.5:          return .east
    case 112.5..<157.5:         return .southEast
    case 157.5..<202.5:         return .south
    case 202.5..<247.5:         return .southWest
    case 247.5..<292.5:         return .west
    case 292.5..<337.5:         return .northWest
    default:                    return .north
    }
}
