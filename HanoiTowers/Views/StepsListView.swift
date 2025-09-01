//
//  StepsListView.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//

import SwiftUI

struct StepsListView: View {
    let steps: [HanoiStep]
    var body: some View {
        List(steps) { s in
            Text("Take disk \(s.disk) from rod \(s.from) to rod \(s.to)")
        }
    }
}

