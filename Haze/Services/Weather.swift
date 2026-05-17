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

func getWeather(for location: CLLocation) async throws -> (temp: Int, condition: AppWeatherCondition) {
    let weather = try await weatherService.weather(for: location)
    let tempF = weather.currentWeather.temperature.converted(to: .fahrenheit)
    let temp = Int(tempF.value.rounded())
    let condition = AppWeatherCondition.from(weather.currentWeather.condition)
    return (temp, condition)
}
