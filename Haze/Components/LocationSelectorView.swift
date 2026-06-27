//
//  LocationSelectorView.swift
//  Haze
//
//  Search sheet behind the header crosshair. Lets the user pick a city
//  (or fall back to their current location) and reports the chosen
//  CLLocation back to the dashboard.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine
import WeatherKit
#if canImport(UIKit)
import UIKit
#endif

struct LocationSelectorView: View {
    let condition: AppWeatherCondition
    /// Reports the chosen location. `nil` means "use my current location".
    let onSelect: (CLLocation?) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @StateObject private var search = CitySearch()
    @State private var query = ""
    @State private var weatherAttribution: WeatherAttribution?
    @FocusState private var fieldFocused: Bool

    var body: some View {
        ZStack {
            condition.backgroundColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // MARK: Header
                HStack(alignment: .center) {
                    Text("SELECT LOCATION")
                        .font(.system(size: 11, weight: .regular, design: .serif))
                        .kerning(3.5)
                        .foregroundStyle(condition.primaryText)

                    Spacer()

                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .light))
                            .foregroundStyle(condition.primaryText)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 28)
                .padding(.bottom, 22)

                // MARK: Search field
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(condition.secondaryText)

                    TextField("", text: $query,
                              prompt: Text("SEARCH CITY")
                        .foregroundColor(condition.secondaryText.opacity(0.55)))
                        .font(.system(size: 13, weight: .regular, design: .serif))
                        .kerning(1)
                        .foregroundStyle(condition.primaryText)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .focused($fieldFocused)
                        .submitLabel(.search)
                        .onChange(of: query) { _, newValue in
                            search.update(query: newValue)
                        }

                    if !query.isEmpty {
                        Button {
                            query = ""
                            search.update(query: "")
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 13, weight: .light))
                                .foregroundStyle(condition.secondaryText)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 12)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundStyle(condition.secondaryText)
                }

                // MARK: Results
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0) {

                        // Current-location row (only when not searching)
                        if query.isEmpty {
                            row(title: "CURRENT LOCATION",
                                subtitle: "USE MY DEVICE LOCATION",
                                leading: "location") {
                                onSelect(nil)
                                dismiss()
                            }
                        }

                        ForEach(search.results.indices, id: \.self) { i in
                            let result = search.results[i]
                            row(title: result.title.uppercased(),
                                subtitle: result.subtitle.uppercased(),
                                leading: nil) {
                                resolve(result)
                            }
                        }
                    }
                    .padding(.top, 6)
                }

                // MARK: Footer
                HStack(spacing: 10) {
                    if let attribution = weatherAttribution {
                        Link(destination: attribution.legalPageURL) {
                            AsyncImage(url: condition.isDark
                                       ? attribution.combinedMarkDarkURL
                                       : attribution.combinedMarkLightURL) { image in
                                image.resizable().scaledToFit().frame(height: 10)
                            } placeholder: {
                                Text("APPLE WEATHER")
                                    .fontDesign(.serif)
                                
                            }
                        }
                    } else {
                        Button {
                            openURL(URL(string: "https://weatherkit.apple.com/legal-attribution.html")!)
                        } label: {
                            Text("APPLE WEATHER")
                                .fontDesign(.serif)
                        }
                    }
                    separator
                    Button {
                        openURL(URL(string: "https://hazeos.info/privacy")!)
                    } label: {
                        Text("Privacy")
                    }
                    separator
                    Button {
                        openURL(URL(string: "https://hazeos.info/terms")!)
                    } label: {
                        Text("Terms")
                    }
                }
                .font(.system(size: 10, weight: .bold, design: .default))
                .foregroundStyle(Color(.black))
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .padding(.horizontal, 24)
        }
        .presentationDragIndicator(.visible)
        .onAppear { fieldFocused = true }
        .task { weatherAttribution = try? await weatherService.attribution }
    }

    private var separator: some View {
        Text("·")
            .font(.system(size: 7, weight: .regular, design: .serif))
            .foregroundStyle(condition.secondaryText.opacity(0.3))
    }

    // MARK: - Row

    @ViewBuilder
    private func row(title: String, subtitle: String, leading: String?,
                     action: @escaping () -> Void) -> some View {
        Button {
            #if canImport(UIKit)
            UISelectionFeedbackGenerator().selectionChanged()
            #endif
            action()
        } label: {
            HStack(spacing: 12) {
                if let leading {
                    Image(systemName: leading)
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(condition.primaryText)
                        .frame(width: 16)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 13, weight: .regular, design: .serif))
                        .kerning(1.5)
                        .foregroundStyle(condition.primaryText)
                        .lineLimit(1)

                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 9, weight: .regular, design: .serif))
                            .kerning(1)
                            .foregroundStyle(condition.secondaryText)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)

        Rectangle()
            .frame(height: 0.5)
            .foregroundStyle(condition.secondaryText.opacity(0.25))
    }

    // MARK: - Resolve completion → coordinates

    private func resolve(_ completion: MKLocalSearchCompletion) {
        Task {
            let request = MKLocalSearch.Request(completion: completion)
            let response = try? await MKLocalSearch(request: request).start()
            if let location = response?.mapItems.first?.location {
                onSelect(location)
                dismiss()
            }
        }
    }
}

// MARK: - Autocomplete

/// Thin wrapper around MKLocalSearchCompleter that publishes city completions.
@MainActor
final class CitySearch: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []

    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }

    func update(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            results = []
        } else {
            completer.queryFragment = trimmed
        }
    }

    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let newResults = completer.results
        Task { @MainActor in self.results = newResults }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter,
                               didFailWithError error: Error) {
        Task { @MainActor in self.results = [] }
    }
}

#Preview {
    LocationSelectorView(condition: .clear) { _ in }
}
