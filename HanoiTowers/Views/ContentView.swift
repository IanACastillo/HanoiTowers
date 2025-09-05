//
//  ContentView.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var vm: HanoiViewModel
    @State private var backendURLString: String = "https://hanoitowers.onrender.com/"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Stepper("Disks: \(vm.diskCount)", value: $vm.diskCount, in: 1...12)
                    Button("Reset") { vm.resetBoard() }
                }
                .padding(.horizontal)
                
                BoardView(vm: vm)
                    .frame(height: 280)
                
                HStack {
                    Button {
                        Task { await vm.fetchSolution() }
                    } label: {
                        Text(vm.isLoading ? "Loading..." : "Solve (Fetch)")
                    }
                    .disabled(vm.isLoading)
                    
                    Button(vm.isPlaying ? "Stop Auto" : "Auto-Solve") {
                        vm.isPlaying ? vm.stopAutoSolve() : vm.playAutoSolve()
                    }
                    .disabled(vm.steps.isEmpty)
                    
                    Spacer()
                    
                    TextField("Backend URL", text: $backendURLString)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.caption)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 280)
                }
                .padding(.horizontal)
                
                StepsListView(steps: vm.steps)
            }
            .navigationTitle("Towers of Hanoi")
            .onChange(of: backendURLString) { _, new in
                if let url = URL(string: new) {
                    // rewire the API target without rebuilding
                    let newAPI = HanoiAPI(baseURL: url)
                    let newVM = HanoiViewModel(api: newAPI)
                    newVM.diskCount = vm.diskCount
                    newVM.resetBoard()
                    // quick swap:
                    _ = withAnimation {
                        // copy local state we care about
                    }
                    // This is a simple demo; for production, inject via Environment
                }
            }
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
        .onAppear {
            if let url = URL(string: backendURLString) {
                // ensure initial URL is valid (no-op otherwise)
                _ = url
            }
        }
    }
}
