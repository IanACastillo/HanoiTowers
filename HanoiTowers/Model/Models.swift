//
//  Models.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//

import Foundation

struct HanoiStep: Codable, Identifiable {
    let id = UUID()
    let disk: Int
    let from: String
    let to: String
    
    enum CodingKeys: String, CodingKey { case disk; case from = "from"; case to }
}

struct SolveResponse: Codable {
    let disks: Int
    let count: Int
    let steps: [HanoiStep]
}

enum Rod: String, CaseIterable { case A, B, C }

struct RodState: Equatable {
    // Stack top is last
    var disks: [Int]
}
