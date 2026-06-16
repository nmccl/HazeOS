//
//  WeatherManager.swift
//  Haze
//
//  Created by Noah McClung on 5/17/26.
//
import Foundation
import Combine
import WeatherKit

final class WeatherManager: ObservableObject {
    private let weatherService = WeatherService()
}
