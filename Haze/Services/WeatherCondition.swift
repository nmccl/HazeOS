//
//  WeatherCondition.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//

import Foundation
import WeatherKit
import CoreLocation
import SwiftUI

enum AppWeatherCondition: String, CaseIterable {
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
    
    var iconGradient: LinearGradient {

        switch self {

        case .clear:

            return LinearGradient(

                colors: [

                    Color(hex: "#F6E7C1"), // warm cream

                    Color(hex: "#D9A441"), // muted gold

                    Color(hex: "#8F5B2E")  // sunset bronze

                ],

                startPoint: .topLeading,

                endPoint: .bottomTrailing

            )

        case .cloudy:

            return LinearGradient(

                colors: [

                    Color(hex: "#D8D8D8"), // soft silver

                    Color(hex: "#8F949B"), // muted graphite

                    Color(hex: "#4A4F57")  // deep storm gray

                ],

                startPoint: .top,

                endPoint: .bottom

            )

        case .rainy:

            return LinearGradient(

                colors: [

                    Color(hex: "#A6B6C9"), // mist blue

                    Color(hex: "#5F6F82"), // rain slate

                    Color(hex: "#2E3947")  // deep wet asphalt

                ],

                startPoint: .topLeading,

                endPoint: .bottomTrailing

            )

        case .snowy:

            return LinearGradient(

                colors: [

                    Color(hex: "#FFFFFF"), // snow white

                    Color(hex: "#DCE5EC"), // icy gray

                    Color(hex: "#AAB7C4")  // frozen steel

                ],

                startPoint: .top,

                endPoint: .bottom

            )

        case .thunderstorm:

            return LinearGradient(

                colors: [

                    Color(hex: "#D7C7FF"), // electric lavender

                    Color(hex: "#6E5A9E"), // storm violet

                    Color(hex: "#1C1B2B")  // deep midnight

                ],

                startPoint: .topLeading,

                endPoint: .bottomTrailing

            )

        case .foggy:

            return LinearGradient(

                colors: [

                    Color(hex: "#E8E6E3"), // pale fog

                    Color(hex: "#B8B5B0"), // warm concrete

                    Color(hex: "#6E6B67")  // muted stone

                ],

                startPoint: .top,

                endPoint: .bottom

            )

        case .hazy:

            return LinearGradient(

                colors: [

                    Color(hex: "#F2D7B6"), // dusty sunlight

                    Color(hex: "#C49A6C"), // desert haze

                    Color(hex: "#70584A")  // smoky earth

                ],

                startPoint: .topLeading,

                endPoint: .bottomTrailing

            )

        }

    }
    var backgroundGradient: LinearGradient {
        switch self {
        case .clear:

               return LinearGradient(

                   colors: [

                       Color(hex: "#FFFDD0"), // deep charcoal

                       Color(hex: "#A59079"), // warm dusk brown

                       Color(hex: "#6B4726")  // muted sunset bronze

                   ],

                   startPoint: .topLeading,

                   endPoint: .bottomTrailing

               )

           case .cloudy:

               return LinearGradient(

                   colors: [

                       Color(hex: "#111111"), // near black

                       Color(hex: "#2A2D31"), // graphite

                       Color(hex: "#4B4F56")  // soft storm gray

                   ],

                   startPoint: .top,

                   endPoint: .bottom

               )

           case .rainy:

               return LinearGradient(

                   colors: [

                       Color(hex: "#050608"), // deep night

                       Color(hex: "#1B2735"), // rain blue

                       Color(hex: "#314052")  // wet concrete

                   ],

                   startPoint: .topLeading,

                   endPoint: .bottomTrailing

               )

           case .snowy:

               return LinearGradient(

                   colors: [

                       Color(hex: "#DCE3EA"), // icy white

                       Color(hex: "#B8C2CC"), // frozen gray

                       Color(hex: "#7E8A96")  // cold steel

                   ],

                   startPoint: .top,

                   endPoint: .bottom

               )

           case .thunderstorm:

               return LinearGradient(

                   colors: [

                       Color(hex: "#050507"), // almost black

                       Color(hex: "#1B1A2E"), // deep indigo

                       Color(hex: "#3A3457")  // storm violet

                   ],

                   startPoint: .topLeading,

                   endPoint: .bottomTrailing

               )

           case .foggy:

               return LinearGradient(

                   colors: [

                       Color(hex: "#B8B5B0"), // pale concrete

                       Color(hex: "#8C8A86"), // warm fog

                       Color(hex: "#5F5C58")  // muted stone

                   ],

                   startPoint: .top,

                   endPoint: .bottom

               )

           case .hazy:

               return LinearGradient(

                   colors: [

                       Color(hex: "#2A211C"), // smoky brown

                       Color(hex: "#6B5444"), // dusty bronze

                       Color(hex: "#A68463")  // hazy sunlight

                   ],

                   startPoint: .topLeading,

                   endPoint: .bottomTrailing

               )

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
extension Color {

    init(hex: String) {

        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64

        switch hex.count {

        case 3:

            (a, r, g, b) = (

                255,

                (int >> 8) * 17,

                (int >> 4 & 0xF) * 17,

                (int & 0xF) * 17

            )

        case 6:

            (a, r, g, b) = (

                255,

                int >> 16,

                int >> 8 & 0xFF,

                int & 0xFF

            )

        case 8:

            (a, r, g, b) = (

                int >> 24,

                int >> 16 & 0xFF,

                int >> 8 & 0xFF,

                int & 0xFF

            )

        default:

            (a, r, g, b) = (255, 0, 0, 0)

        }

        self.init(

            .sRGB,

            red: Double(r) / 255,

            green: Double(g) / 255,

            blue: Double(b) / 255,

            opacity: Double(a) / 255

        )

    }

}
enum WindDirection: String, CaseIterable {
    case north, northEast, east, southEast, south, southWest, west, northWest

    var arrowSymbol: String {
        switch self {
        case .north:     return "arrow.up"
        case .northEast: return "arrow.up.right"
        case .east:      return "arrow.right"
        case .southEast: return "arrow.down.right"
        case .south:     return "arrow.down"
        case .southWest: return "arrow.down.left"
        case .west:      return "arrow.left"
        case .northWest: return "arrow.up.left"
        }
    }

    var abbreviated: String {
        switch self {
        case .north:     return "N"
        case .northEast: return "NE"
        case .east:      return "E"
        case .southEast: return "SE"
        case .south:     return "S"
        case .southWest: return "SW"
        case .west:      return "W"
        case .northWest: return "NW"
        }
    }
}
