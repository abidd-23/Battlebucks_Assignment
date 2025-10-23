//
//  PostsViewModel.swift
//  Battlebucks
//
//  Created by Abid on 10/22/2025.
//

import Foundation
import Combine

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var favoritePosts: Set<Int> = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var favorites: [Post] {
        return posts.filter { favoritePosts.contains($0.id) }
    }
    
    func fetchPosts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            posts = try await networkService.fetchPosts()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = handleError(error)
        }
    }
    
    func toggleFavorite(postId: Int) {
        if favoritePosts.contains(postId) {
            favoritePosts.remove(postId)
        } else {
            favoritePosts.insert(postId)
        }
    }
    
    func isFavorite(postId: Int) -> Bool {
        return favoritePosts.contains(postId)
    }
    
    private func handleError(_ error: Error) -> String {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidURL:
                return "Invalid URL"
            case .invalidResponse:
                return "Invalid server response"
            case .decodingError:
                return "Failed to decode data"
            case .serverError(let message):
                return "Server error: \(message)"
            }
        } else {
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}

