//
//  WeatherCondition.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//

import Foundation
import WeatherKit
import CoreLocation

enum AppWeatherCondition: String {
    case clear
    case cloudy
    case rainy
    case snowy
    case thunderstorm
    case foggy
    case hazy

    /// The SF Symbol name to display for this condition
    var sfSymbol: String {
        switch self {
        case .clear:       return "sun.max"
        case .cloudy:      return "cloud"
        case .rainy:       return "cloud.rain"
        case .snowy:       return "cloud.snow"
        case .thunderstorm: return "cloud.bolt.rain"
        case .foggy:       return "cloud.fog"
        case .hazy:        return "sun.haze"
        }
    }

    /// The vertical letter-stacked label shown beside the symbol
    var label: String {
        switch self {
        case .clear:        return "C\nL\nE\nA\nR"
        case .cloudy:       return "C\nL\nO\nU\nD\nY"
        case .rainy:        return "R\nA\nI\nN\nY"
        case .snowy:        return "S\nN\nO\nW\nY"
        case .thunderstorm: return "T\nH\nU\nN\nD\nE\nR"
        case .foggy:        return "F\nO\nG\nG\nY"
        case .hazy:         return "H\nA\nZ\nY"
        }
    }
}

extension AppWeatherCondition {
    static func from(_ condition: WeatherCondition) -> AppWeatherCondition {
        switch condition {
        case .clear, .mostlyClear:
            return .clear
        case .cloudy, .mostlyCloudy, .partlyCloudy:
            return .cloudy
        case .rain, .drizzle, .heavyRain:
            return .rainy
        case .snow, .heavySnow, .flurries, .blowingSnow, .sleet:
            return .snowy
        case .thunderstorms, .isolatedThunderstorms, .scatteredThunderstorms:
            return .thunderstorm
        case .foggy:
            return .foggy
        case .haze, .smoky, .blowingDust:
            return .hazy
        default:
            return .clear
        }
    }
}
