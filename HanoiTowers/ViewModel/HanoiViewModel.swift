//
//  HanoiViewModel.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//

import Foundation
import SwiftUI

@MainActor
final class HanoiViewModel: ObservableObject {
    @Published var diskCount: Int = 3
    @Published var steps: [HanoiStep] = []
    @Published var rods: [Rod: RodState] = [.A: RodState(disks: [3,2,1]), .B: RodState(disks: []), .C: RodState(disks: [])]
    @Published var isPlaying: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let api: HanoiAPI
    private var playbackTask: Task<Void, Never>? = nil
    
    init(api: HanoiAPI) {
        self.api = api
        resetBoard()
    }
    
    func resetBoard() {
        rods[.A] = RodState(disks: Array(1...diskCount).reversed())
        rods[.B] = RodState(disks: [])
        rods[.C] = RodState(disks: [])
        isPlaying = false
        steps = []
        errorMessage = nil
        playbackTask?.cancel()
        playbackTask = nil
    }
    
    func fetchSolution() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let res = try await api.solve(disks: diskCount)
            steps = res.steps
        } catch {
            errorMessage = "Failed to fetch solution. Is the backend running?"
        }
    }
    
    func canPick(from rod: Rod) -> Bool {
        guard let top = rods[rod]?.disks.last else { return false }
        // Only allow picking if that top disk is the smallest available across all rods?
        // Classic rule: you can always move the top disk; legality is decided on drop.
        return top > 0
    }
    
    func canDrop(disk: Int, to rod: Rod) -> Bool {
        guard let top = rods[rod]?.disks.last else { return true } // empty OK
        return top > disk
    }
    
    func moveTop(from: Rod, to: Rod) -> Bool {
        guard var src = rods[from], var dst = rods[to], let d = src.disks.last else { return false }
        guard canDrop(disk: d, to: to) else { return false }
        src.disks.removeLast()
        dst.disks.append(d)
        rods[from] = src
        rods[to] = dst
        return true
    }
    
    func playAutoSolve(stepDelay: Double = 0.35) {
        guard !steps.isEmpty else { return }
        isPlaying = true
        playbackTask?.cancel()
        resetBoard()
        playbackTask = Task { [weak self] in
            guard let self else { return }
            for s in steps {
                if Task.isCancelled { break }
                try? await Task.sleep(nanoseconds: UInt64(stepDelay * 1_000_000_000))
                _ = moveTop(from: Rod(rawValue: s.from)!, to: Rod(rawValue: s.to)!)
            }
            await MainActor.run { self.isPlaying = false }
        }
    }
    
    func stopAutoSolve() {
        playbackTask?.cancel()
        playbackTask = nil
        isPlaying = false
    }
}
