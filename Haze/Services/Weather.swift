//
//  Weather.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//
import Foundation
import WeatherKit
import CoreLocation

let weatherService = WeatherService.shared

public func getWeather(for location: CLLocation) async throws -> Int {
    let weather = try await weatherService.weather(for: location)
    let tempF = weather.currentWeather.temperature.converted(to: .fahrenheit)
    var currentWeather = Int(tempF.value.rounded())
    
    return currentWeather
}

// NOTE: You cannot call async/throwing functions at global scope.
// Call `getWeather(for:)` from an async context, e.g., within a SwiftUI `.task` or an async function:
//
// Task {
//     do {
//         let temp = try await getWeather(for: CLLocation(latitude: 37.7749, longitude: -122.4194))
//         print("Local temp: ", temp)
//     } catch {
//         print("Failed to fetch weather:", error)
//     }
// }
