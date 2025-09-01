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
            let api = HanoiAPI(baseURL: URL(string: "http://127.0.0.1:8000/")!)
            ContentView(vm: HanoiViewModel(api: api))
        }
    }
}

