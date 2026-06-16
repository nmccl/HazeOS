//
//  WeeklyView.swift
//  Haze
//

import SwiftUI

struct WeeklyView: View {
    let condition: AppWeatherCondition
    var isActive: Bool
    var forecast: [DayForecast] = []

    var body: some View {
        HStack(spacing: 0) {
            if forecast.isEmpty {
                // Placeholder columns while data loads
                ForEach(0..<5, id: \.self) { _ in
                    DayColumn(label: "—", iconName: "icon_sun",
                              high: 0, low: 0, isActive: false, condition: condition,
                              placeholder: true)
                }
            } else {
                ForEach(forecast.indices, id: \.self) { i in
                    DayColumn(
                        label:     forecast[i].label,
                        iconName:  forecast[i].iconName,
                        high:      forecast[i].high,
                        low:       forecast[i].low,
                        isActive:  i == 0 && isActive,
                        condition: condition
                    )
                }
            }
        }
    }
}

// MARK: - Day Column

private struct DayColumn: View {
    let label:       String
    let iconName:    String
    let high:        Int
    let low:         Int
    let isActive:    Bool
    let condition:   AppWeatherCondition
    var placeholder: Bool = false

    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.system(size: 9, weight: isActive ? .medium : .regular))
                .kerning(0.5)
                .foregroundStyle(isActive ? condition.primaryText : condition.secondaryText)

            weatherIcon

            Text(placeholder ? "—" : "\(high)°")
                .font(.system(size: 10, weight: isActive ? .medium : .regular))
                .foregroundStyle(isActive ? condition.primaryText : condition.secondaryText)

            Text(placeholder ? "—" : "\(low)°")
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(condition.secondaryText)
        }
        .opacity(placeholder ? 0.3 : 1)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var weatherIcon: some View {
        if condition.isDark {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .colorInvert()
                .blendMode(.screen)
        } else {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .blendMode(.multiply)
        }
    }
}

#Preview {
    ZStack {
        AppWeatherCondition.clear.backgroundColor.ignoresSafeArea()
        WeeklyView(condition: .clear, isActive: true)
            .padding(.horizontal, 24)
    }
}
