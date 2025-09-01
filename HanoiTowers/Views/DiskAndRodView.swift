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
    var body: some View {
        let width = CGFloat(60 + (sizeIndex - 1) * 18)
        RoundedRectangle(cornerRadius: 8)
            .frame(width: width, height: 24)
            .overlay(Text("\(sizeIndex)").font(.caption).bold().foregroundStyle(.white))
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
