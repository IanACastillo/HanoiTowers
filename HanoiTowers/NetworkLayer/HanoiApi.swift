//
//  HanoiApi.swift
//  HanoiTowers
//
//  Created by Ian Castillo on 9/1/25.
//

import Foundation

final class HanoiAPI {
    let baseURL: URL
    init(baseURL: URL) { self.baseURL = baseURL }
    
    struct SolveRequest: Codable {
        let disks: Int
        let from: String
        let to: String
        let aux: String
    }
    
    func solve(disks: Int, from: Rod = .A, to: Rod = .C, aux: Rod = .B) async throws -> SolveResponse {
        let url = baseURL.appendingPathComponent("solve")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = SolveRequest(disks: disks, from: from.rawValue, to: to.rawValue, aux: aux.rawValue)
        req.httpBody = try JSONEncoder().encode(body)
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(SolveResponse.self, from: data)
    }
}
