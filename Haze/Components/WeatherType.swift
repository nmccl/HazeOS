////
////  WeatherType.swift
////  Haze
////
//
//import SwiftUI
//
//struct WeatherType: View {
//    let condition: AppWeatherCondition
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 0) {
//
//            // Illustration — the full emotional centre of the screen
//            WeatherIllustration(condition: condition)
//                .frame(maxWidth: .infinity, alignment: .center)
//
//            // Vertical condition label — each character individually spaced,
//            // reads like an editorial spine or instrument panel readout
//            VStack(alignment: .leading, spacing: 6) {
//                ForEach(
//                    Array(condition.rawValue.uppercased().enumerated()),
//                    id: \.offset
//                ) { _, char in
//                    Text(String(char))
//                        .font(.system(size: 9, weight: .regular))
//                        .kerning(0.5)
//                        .foregroundStyle(condition.secondaryText)
//                }
//                Spacer()
//            }
//            .padding(.top, 24)
//            .padding(.trailing, 24)
//        }
//        .frame(width: 380, height: 300)
//    }
//}
//
//#Preview {
//    ZStack {
//        AppWeatherCondition.clear.backgroundColor.ignoresSafeArea()
//        WeatherType(condition: .clear)
//    }
//}
