//
//  DashboardView.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//

import SwiftUI

struct DashboardView: View {
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
                HStack(alignment: .firstTextBaseline){
                    CurrentWeather()
                        .padding(40)
                        //.padding(.trailing, 180)
                }
                WeatherType()
                Spacer()
                City()
                    .padding()
                WeeklyView(isActive: true)
                Spacer()
            }
        }
    }
}

#Preview {
    DashboardView()
}
