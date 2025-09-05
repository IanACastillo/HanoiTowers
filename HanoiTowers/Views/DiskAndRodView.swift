//
//  DiskAndRodView.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//

import SwiftUI

struct DiskView: View {
    let sizeIndex: Int  // 1 = smallest, larger = wider
    let maxSize: Int
    
    // Cycle colors every 3: 1→navy, 2→green, 3→orange, 4→navy, ...
    private var diskColor: Color {
        switch (sizeIndex - 1) % 3 {
        case 0:
            // Navy blue
            return Color(.sRGB, red: 0.0, green: 0.0, blue: 0.5, opacity: 1.0)
        case 1:
            // Opaque green (slightly translucent for a modern look)
            return Color.green.opacity(0.8)
        default:
            // Opaque orange
            return Color.orange.opacity(0.8)
        }
    }
    
    var body: some View {
        let width = CGFloat(60 + (sizeIndex - 1) * 18)
        RoundedRectangle(cornerRadius: 8)
            .fill(diskColor)
            .frame(width: width, height: 24)
            .overlay(
                Text("\(sizeIndex)")
                    .font(.caption).bold()
                    .foregroundStyle(.white)
                    .shadow(radius: 1)
            )
            .shadow(radius: 2, y: 1) // subtle depth
    }
}


struct RodView: View {
    let label: String
    let disks: [Int]      // bottom ... top
    let maxDisks: Int
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .frame(width: 12, height: CGFloat(28 * maxDisks))
                VStack(spacing: 6) {
                    ForEach(disks.reversed(), id: \.self) { d in
                        DiskView(sizeIndex: d, maxSize: maxDisks)
                    }
                }
                .padding(.bottom, 4)
            }
            Text(label).font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
}
