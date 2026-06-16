//
//  CurrentWeather.swift
//  Haze
//

import SwiftUI
import CoreLocation

struct CurrentWeather: View {
    @State private var currentTemp: Int? = nil
    @State private var typeIndicator = "F"
    let condition: AppWeatherCondition

    @EnvironmentObject var locationFetcher: LocationFetcher

    var body: some View {
        HStack(alignment: .top, spacing: 0) {

            // Primary reading — large, light, undecorated
            Text(currentTemp.map { "\($0)" } ?? "—")
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(condition.primaryText)

            // Degree + unit — secondary, tucked into top-right of the number
            VStack(alignment: .leading, spacing: 2) {
                Text("°")
                    .font(.system(size: 22, weight: .light))
                    .foregroundStyle(condition.primaryText)
                    .padding(.top, 10)   // optically aligns to cap-height

                Text(typeIndicator)
                    .font(.system(size: 11, weight: .regular))
                    .kerning(0.5)
                    .foregroundStyle(condition.secondaryText)
            }
            .padding(.leading, 3)
        }
        .fixedSize(horizontal: true, vertical: true)
        .task(id: locationFetcher.location) {
            guard let loc = locationFetcher.location else { return }
            await loadWeather(for: loc)
        }
    }

    private func loadWeather(for location: CLLocation) async {
        do {
            let result = try await getWeather(for: location)
            currentTemp = result.temp
            typeIndicator = "F"
        } catch {
            print("Failed to load weather:", error)
            currentTemp = nil
        }
    }
}
