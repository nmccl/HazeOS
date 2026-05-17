//
//  HazeApp.swift
//  Haze
//
//  Created by Noah McClung on 5/16/26.
//

import SwiftUI

@main
struct HazeApp: App {
    @StateObject private var locationFetcher = LocationFetcher()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationFetcher)
        }
    }
}
