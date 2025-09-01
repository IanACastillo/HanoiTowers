//
//  BoardView.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//


import SwiftUI

struct BoardView: View {
    @ObservedObject var vm: HanoiViewModel
    @State private var selectedRod: Rod? = nil
    
    var body: some View {
        HStack(spacing: 32) {
            ForEach(Rod.allCases, id: \.self) { rod in
                VStack {
                    RodView(label: rod.rawValue,
                            disks: vm.rods[rod]?.disks ?? [],
                            maxDisks: vm.diskCount)
                        .onTapGesture {
                            if let from = selectedRod {
                                if vm.moveTop(from: from, to: rod) {
                                    selectedRod = nil
                                } else {
                                    // illegal move, reset selection
                                    selectedRod = nil
                                }
                            } else {
                                // first tap = select rod
                                if vm.canPick(from: rod) {
                                    selectedRod = rod
                                }
                            }
                        }
                    if selectedRod == rod {
                        Text("Selected").foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
    }
}
