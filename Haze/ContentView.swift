//
//  ContentView.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
//            AdvancedView()
//            SettingsView()
        }
        .tabViewStyle(.page) // Converts tabs into dots
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .ignoresSafeArea()

    }
}

#Preview {
    ContentView()
        .environmentObject(LocationFetcher(requestsAuthorization: false))
}
