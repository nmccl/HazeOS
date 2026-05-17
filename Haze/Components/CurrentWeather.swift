//
//  CurrentWeather.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//
import SwiftUI
import CoreLocation
import Combine
// MARK: - Location helper
// A small observable object that requests the device's real location once
// and publishes it so CurrentWeather can react when it arrives.
@MainActor
final class LocationFetcher: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation? = nil

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        // Only request permission here — we wait for the delegate callback
        // before calling requestLocation() so the OS has time to show the
        // permission dialog and the user can respond.
        manager.requestWhenInUseAuthorization()
    }

    // Called whenever the authorization status changes (including the first
    // time the user taps Allow/Don't Allow on the permission dialog).
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted — now it's safe to ask for a location fix.
            manager.requestLocation()
        case .denied, .restricted:
            print("Location access denied — showing placeholder temperature.")
        default:
            break // .notDetermined: dialog not answered yet, wait
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        Task { @MainActor in self.location = loc }
    }

    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didFailWithError error: Error) {
        print("Location error:", error)
    }
}

// MARK: - View
struct CurrentWeather: View {
    // Holds the fetched temperature
    @State private var currentTemp: Int? = nil
    // Adjust if your getWeather returns Celsius instead
    @State private var typeIndicator = "F"
    @State private var errorMessage: String? = nil

    @StateObject private var locationFetcher = LocationFetcher()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
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
        // Re-fetch whenever the real location arrives
        .onChange(of: locationFetcher.location) { _, newLocation in
            guard let loc = newLocation else { return }
            Task { await loadWeather(for: loc) }
        }

        // Temporary debug label — remove once weather is working
        if let msg = errorMessage {
            Text(msg)
                .font(.caption)
                .foregroundStyle(.red)
                .fixedSize(horizontal: false, vertical: true)
        }
        } // end outer VStack
    }

    // MARK: - Load using existing weather function
    private func loadWeather(for location: CLLocation) async {
        do {
            let temp = try await getWeather(for: location)
            currentTemp = temp
            typeIndicator = "F" // change to "C" if getWeather returns Celsius
            errorMessage = nil
        } catch {
            print("Failed to load weather:", error)
            errorMessage = error.localizedDescription
            currentTemp = nil
        }
    }
}

#Preview {
    CurrentWeather()
}
