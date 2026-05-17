//
//  DashboardView.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//

import SwiftUI
import CoreLocation

struct DashboardView: View {
    @State private var condition: AppWeatherCondition? = nil

    @EnvironmentObject var locationFetcher: LocationFetcher

    var body: some View {
        ZStack {
            // Hazy weather gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.0)),
                    Color(#colorLiteral(red: 0.75, green: 0.80, blue: 0.85, alpha: 1.0)),
                    Color(#colorLiteral(red: 0.66, green: 0.68, blue: 0.70, alpha: 1.0))
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Existing content
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    CurrentWeather()
                        .padding(40)
                }
                if let condition {
                    WeatherType(condition: condition)
                }
                Spacer()
                City()
                    .padding()
                WeeklyView(isActive: true)
                Spacer()
            }
        }
        .task(id: locationFetcher.location) {
            guard let loc = locationFetcher.location else { return }
            await loadCondition(for: loc)
        }
    }

    private func loadCondition(for location: CLLocation) async {
        do {
            let result = try await getWeather(for: location)
            condition = result.condition
            print("Condition loaded:", result.condition.rawValue)
        } catch {
            print("Failed to load condition:", error)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(LocationFetcher())
}
