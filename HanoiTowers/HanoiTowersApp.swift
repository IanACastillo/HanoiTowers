//
//  HanoiTowersApp.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//

import SwiftUI
import SwiftData

@main
struct HanoiApp: App {
    var body: some Scene {
        WindowGroup {
            // Always use cloud service
            let api = HanoiAPI(baseURL: URL(string: "https://hanoitowers.onrender.com/")!)
            ContentView(vm: HanoiViewModel(api: api))
        }
    }
}

