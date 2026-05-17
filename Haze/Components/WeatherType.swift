//
//  WeatherType.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//
import SwiftUI

struct WeatherType: View {
    let condition: AppWeatherCondition

    var body: some View {
        HStack {
            Image(systemName: condition.sfSymbol)
                .font(.system(size: 200))
                .padding(.leading, 20)
                .frame(maxWidth: .infinity)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(0.8),
                            Color.yellow.opacity(0.3),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            VStack {
                Text(condition.label)
                Spacer()
            }
        }
        .frame(width: 380, height: 300)
    }
}

#Preview {
    WeatherType(condition: .clear)
}
