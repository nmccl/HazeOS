//
//  WeatherAppearance.swift
//  Haze
//
//  UI-only extension — maps each condition to a flat colour system.
//  Does not touch any backend/model logic.
//

import SwiftUI

extension AppWeatherCondition {

    // MARK: - Backgrounds (flat, paper-like — no gradient)

    var backgroundColor: Color {
        switch self {
        case .clear:        return Color(hex: "#F4EFE6")
        case .cloudy:       return Color(hex: "#F0EBE2")
        case .rainy:        return Color(hex: "#EDEAE1")
        case .snowy:        return Color(hex: "#EEF0F5")
        case .thunderstorm: return Color(hex: "#141414")
        case .foggy:        return Color(hex: "#EDE9E3")
        case .hazy:         return Color(hex: "#F5EDD8")
        }
    }

    // MARK: - Accent (one colour per condition — used for illustrations only)

    var accentColor: Color {
        switch self {
        case .clear:        return Color(hex: "#C4312A")   // Japanese red
        case .cloudy:       return Color(hex: "#2D2D2D")   // charcoal
        case .rainy:        return Color(hex: "#292929")   // charcoal
        case .snowy:        return Color(hex: "#3A5070")   // ink blue
        case .thunderstorm: return Color(hex: "#C8A46A")   // aged gold
        case .foggy:        return Color(hex: "#7D7A72")   // warm stone
        case .hazy:         return Color(hex: "#B87A4A")   // desert amber
        }
    }

    // MARK: - Text colours

    var backgroundImageName: String {
        switch self {
        case .clear:        return "bg_sunny"
        case .cloudy:       return "bg_cloudy"
        case .rainy:        return "bg_rainy"
        case .snowy:        return "bg_snowy"
        case .thunderstorm: return "bg_thunderstorm"
        case .foggy:        return "bg_hazy"
        case .hazy:         return "bg_hazy"
        }
    }
    var currentCondition: String {
        switch self {
        case .clear: return "Crystal clear skies"
        case .cloudy: return "Muted daylight"
        case .rainy: return "Steady rainfall"
        case .thunderstorm: return "Unsettled skies"
        case .snowy: return "Fresh snow ahead"
        case .foggy: return "Fog settling in"
        case .hazy: return "Misty surroundings"
        }
    }

    var weeklyIconName: String {
        switch self {
        case .clear:        return "icon_sun"
        case .cloudy:       return "icon_cloud"
        case .rainy:        return "icon_rainy"
        case .snowy:        return "icon_snowy"
        case .thunderstorm: return "icon_thunderstorm"
        case .foggy:        return "icon_partly_cloud"
        case .hazy:         return "icon_partly_cloud"
        }
    }
   

    var isDark: Bool {
        switch self {
        case .thunderstorm: // Add more cases as needed
            return true
        default:
            return false
        }
    }

    var primaryText: Color {
        isDark ? Color(hex: "#EDE5D4") : Color(hex: "#1A1A1A")
    }

    var secondaryText: Color {
        isDark
            ? Color(hex: "#EDE5D4").opacity(0.85)
            : Color(hex: "#1A1A1A").opacity(0.85)
    }
}
