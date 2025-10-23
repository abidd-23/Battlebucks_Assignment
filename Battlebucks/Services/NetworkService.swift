//
//  NetworkService.swift
//  Battlebucks
//
//  Created by Abid on 10/22/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
        } catch {
            throw NetworkError.decodingError
        }
    }
}

