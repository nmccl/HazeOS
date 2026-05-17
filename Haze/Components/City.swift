
import SwiftUI
import CoreLocation

struct City: View {
    @StateObject private var locationFetcher = LocationFetcher()
    @State private var cityName: String = "—"

    var body: some View {
        Text(cityName)
            .textCase(.uppercase)
            .onChange(of: locationFetcher.location) { _, newLocation in
                guard let loc = newLocation else { return }
                Task { await resolveCity(from: loc) }
            }
    }

    private func resolveCity(from location: CLLocation) async {
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            cityName = placemarks.first?.locality ?? "Unknown"
        } catch {
            print("Geocode error:", error)
        }
    }
}
