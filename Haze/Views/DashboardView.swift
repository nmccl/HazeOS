//
//  DashboardView.swift
//  Haze
//

import SwiftUI
import CoreLocation
#if canImport(UIKit)
import UIKit
#endif

struct DashboardView: View {

    // MARK: - State
    

    @State private var liveCondition: AppWeatherCondition?
    @State private var windDirection: WindDirection?
    @State private var liveTemp: Int?
    @State private var windSpeed: Int?
    @State private var forecast: [DayForecast] = []
    @State private var useManualCondition = false
    @State private var manualCondition: AppWeatherCondition = .cloudy

    @State private var cityName: String = "Seattle"
    @State private var regionName: String = "Washington, USA"
   // @State private var condtionDescription =

    @State private var showLocationSelector = false
    /// A manually selected location overrides the device location until cleared.
    @State private var manualLocation: CLLocation?
    @State private var isLoading = false
    @State private var weatherLoadFailed = false

    @EnvironmentObject var locationFetcher: LocationFetcher

    @Environment(\.openURL) private var openURL

    // MARK: - Derived

    /// Manual selection takes precedence over the device's current location.
    private var activeLocation: CLLocation? {
        manualLocation ?? locationFetcher.location
    }

    private var activeCondition: AppWeatherCondition {
        useManualCondition ? manualCondition : (liveCondition ?? .clear)
    }

    private var conditionDescription: String {
        activeCondition.currentCondition
    }

    private var locationDenied: Bool {
        let s = locationFetcher.authorizationStatus
        return (s == .denied || s == .restricted) && manualLocation == nil
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f.string(from: Date()).uppercased()
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Full-screen background illustration
            Image(activeCondition.backgroundImageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 6) {

                // MARK: Header row
                HStack(alignment: .center) {
                    Text(formattedDate)
                        .font(.system(size: 10, weight: .regular, design: .serif))
                        .kerning(1.8)
                        .foregroundStyle(activeCondition.secondaryText)
                        //.padding(.top, 36)

                    Spacer()

                    HStack(spacing: 14) {
//                       
//                        Image(systemName: "line.3.horizontal")
//                            .font(.system(size: 19, weight: .light))
//                            .foregroundStyle(activeCondition.primaryText)
                        Button {
                            #if canImport(UIKit)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            #endif
                            showLocationSelector = true
                        } label: {
                            Image(systemName: "scope")
                                .font(.system(size: 19, weight: .light))
                                .foregroundStyle(activeCondition.primaryText)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 40)

                // MARK: City
                Text(cityName.uppercased())
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(activeCondition.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .padding(.top, 2)

                Text(regionName.uppercased())
                    .font(.system(size: 10, weight: .regular, design: .serif))
                    .kerning(1.5)
                    .foregroundStyle(activeCondition.secondaryText)
                    .padding(.top, 2)

             // MARK: Divider
//                Rectangle()
//                    .frame(height: 0.5)
//                    .foregroundStyle(activeCondition.secondaryText)
                    .padding(.top, 12)

                // MARK: Temperature / Permission Prompt / Error
                if locationDenied {
                    permissionDeniedSection
                } else {
                    // MARK: Temperature
                    HStack(alignment: .top, spacing: 2) {
                        Text(liveTemp.map { "\($0)" } ?? "—")
                            .font(.system(size: 100, weight: .thin, design: .default))
                            .foregroundStyle(activeCondition.primaryText)
                            .opacity(isLoading && liveTemp == nil ? 0.35 : 1.0)
                            .animation(
                                isLoading && liveTemp == nil
                                    ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                                    : .default,
                                value: isLoading
                            )
                        Text("°")
                            .font(.system(size: 36, weight: .light, design: .serif))
                            .foregroundStyle(activeCondition.primaryText)
                            .padding(.top, 14)
                    }
                    .padding(.top, 8)

                    // MARK: Condition label
                    Text(activeCondition.rawValue.uppercased())
                        .font(.system(size: 11, weight: .regular, design: .serif))
                        .kerning(3.5)
                        .foregroundStyle(activeCondition.primaryText)

                    Spacer().frame(height: 20)

                    // MARK: Description pill
                    VStack(alignment: .leading, spacing: 2) {
                        Text(conditionDescription.uppercased())
                    }
                    .font(.system(size: 9, weight: .regular, design: .serif))
                    .kerning(1)
                    .foregroundStyle(activeCondition.secondaryText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(activeCondition.secondaryText.opacity(0.55), lineWidth: 0.6)
                    )

                    Spacer().frame(height: 20)

                    // MARK: Wind
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(activeCondition.primaryText.opacity(0.25), lineWidth: 0.8)
                                .frame(width: 34, height: 34)
                            Image(systemName: windDirection?.arrowSymbol ?? "arrow.up")
                                .font(.system(size: 12, weight: .light))
                                .foregroundStyle(activeCondition.primaryText)
                                .opacity(isLoading && windSpeed == nil ? 0.35 : 1.0)
                                .animation(
                                    isLoading && windSpeed == nil
                                        ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                                        : .default,
                                    value: isLoading
                                )
                        }

                        VStack(alignment: .leading, spacing: 1) {
                            HStack(alignment: .firstTextBaseline, spacing: 3) {
                                Text(windSpeed.map { "\($0)" } ?? "—")
                                    .font(.system(size: 18, weight: .regular, design: .serif))
                                Text("mph")
                                    .font(.system(size: 8, weight: .regular, design: .serif))
                            }
                            Text(windDirection?.abbreviated ?? "—")
                                .font(.system(size: 10, weight: .regular, design: .serif))
                                .kerning(1)
                        }
                        .foregroundStyle(activeCondition.primaryText)
                        .opacity(isLoading && windSpeed == nil ? 0.35 : 1.0)
                        .animation(
                            isLoading && windSpeed == nil
                                ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                                : .default,
                            value: isLoading
                        )
                    }

                    // MARK: Error
                    if weatherLoadFailed {
                        HStack(spacing: 10) {
                            Text("UNABLE TO LOAD WEATHER")
                                .font(.system(size: 9, weight: .regular, design: .serif))
                                .kerning(1)
                                .foregroundStyle(activeCondition.secondaryText)
                            Button("RETRY") {
                                if let loc = activeLocation {
                                    Task { await loadWeather(for: loc) }
                                }
                            }
                            .font(.system(size: 9, weight: .regular, design: .serif))
                            .kerning(1)
                            .foregroundStyle(activeCondition.primaryText)
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 6)
                    }
                }

                Spacer()

                // MARK: Divider before weekly
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(activeCondition.secondaryText)

                // MARK: Weekly strip
                WeeklyView(condition: activeCondition, isActive: true, forecast: forecast)
                    .padding(.top, 14)
                    .padding(.bottom, 50)
            }
            .safeAreaPadding(.top)
            .padding(.horizontal, 24)
        }
        .task(id: activeLocation) {
            guard let loc = activeLocation else { return }
            await resolveLocation(from: loc)
            await loadWeather(for: loc)
        }
        .sheet(isPresented: $showLocationSelector) {
            LocationSelectorView(condition: activeCondition) { location in
                manualLocation = location
            }
            .presentationDetents([.large])
        }
    }

    private func loadWeather(for location: CLLocation) async {
        isLoading = true
        weatherLoadFailed = false
        do {
            let data = try await getWeather(for: location)
            liveTemp = data.temp
            windSpeed = data.windSpeed
            windDirection = data.windDirection
            forecast = data.forecast
            if !useManualCondition { liveCondition = data.condition }
            #if canImport(UIKit)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            #endif
        } catch {
            weatherLoadFailed = true
            #if canImport(UIKit)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            #endif
            print("Failed to load weather:", error)
        }
        isLoading = false
    }

    // MARK: - Permission Denied UI

    @ViewBuilder
    private var permissionDeniedSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("LOCATION ACCESS DISABLED")
                .font(.system(size: 11, weight: .regular, design: .serif))
                .kerning(2.5)
                .foregroundStyle(activeCondition.primaryText)

            Text("Enable location in Settings to see your local weather, or search for a city manually.")
                .font(.system(size: 10, weight: .regular, design: .serif))
                .kerning(0.4)
                .foregroundStyle(activeCondition.secondaryText)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 16) {
                Button("OPEN SETTINGS") {
                    #if canImport(UIKit)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                    #endif
                }
                .font(.system(size: 9, weight: .regular, design: .serif))
                .kerning(2)
                .foregroundStyle(activeCondition.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(activeCondition.primaryText.opacity(0.6), lineWidth: 0.6)
                )
                .buttonStyle(.plain)

                Button("SEARCH CITY") {
                    #if canImport(UIKit)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    #endif
                    showLocationSelector = true
                }
                .font(.system(size: 9, weight: .regular, design: .serif))
                .kerning(2)
                .foregroundStyle(activeCondition.secondaryText)
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 24)
    }

    // MARK: - Data

    private func resolveLocation(from location: CLLocation) async {
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            if let p = placemarks.first {
                cityName = p.locality ?? "—"
                let parts = [p.administrativeArea, p.country].compactMap { $0 }
                regionName = parts.joined(separator: ", ")
            }
        } catch {
            print("Geocode error:", error)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(LocationFetcher())
}
