//
//  CurrentWeather.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//
import SwiftUI
import CoreLocation

struct CurrentWeather: View {
    @State private var currentTemp: Int? = nil
    @State private var typeIndicator = "F"

    @EnvironmentObject var locationFetcher: LocationFetcher

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 5) {
            Text(currentTemp.map { "\($0)" } ?? "—")
                .font(.system(size: 120, weight: .thin))

            VStack(alignment: .leading, spacing: 0) {
                Text("°")
                    .font(.system(size: 50, weight: .thin))
                    .padding(.top)

                Spacer(minLength: 0)

                Text(typeIndicator)
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 120)
            .padding(.leading, 2)
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

#Preview {
    CurrentWeather()
        .environmentObject(LocationFetcher())
}
