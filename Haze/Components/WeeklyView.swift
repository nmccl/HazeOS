//
//  WeeklyView.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//

import SwiftUI

struct WeeklyView: View {
    var isActive: Bool
    var body: some View {
        HStack(spacing: 30){
            VStack(spacing: 10){
                Image(systemName:"sun.max")
                    .font(.system(size: 25))
                if !isActive {
                    Text("Mon")
                } else {
                    Text("Mon")
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.gray.opacity(0.3))
                        )
                }
            }
            VStack(spacing: 10){
                Image(systemName:"sun.dust")
                    .font(.system(size: 25))
                Text("Tues")
            }
            VStack(spacing: 10){
                Image(systemName:"sun.haze")
                    .font(.system(size: 25))
                Text("Wed")
            }
            VStack(spacing: 10){
                Image(systemName:"cloud.rain")
                    .font(.system(size: 25))
                Text("Thur")
            }
            VStack(spacing: 10){
                Image(systemName:"cloud.rain")
                    .font(.system(size: 25))
                Text("Fri")
            }
            VStack(spacing: 10){
                Image(systemName:"cloud.sun")
                    .font(.system(size: 25))
                Text("Sat")
            }
        }
    }
}

#Preview {
    WeeklyView(isActive: true)
}
