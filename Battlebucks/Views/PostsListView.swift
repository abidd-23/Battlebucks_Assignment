//
//  PostsListView.swift
//  Battlebucks
//
//  Created by Abid on 10/22/2025.
//

import SwiftUI

struct PostsListView: View {
    @ObservedObject var viewModel: PostsViewModel
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.background, Color.theme.cardBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                GameHeaderView(title: "Battle Posts")
                    .padding(.top, 10)
                
                // Search Bar
                GameSearchBar(searchText: $viewModel.searchText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                
                if viewModel.isLoading {
                    Spacer()
                    GameLoadingView()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    GameErrorView(errorMessage: errorMessage) {
                        Task {
                            await viewModel.fetchPosts()
                        }
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredPosts) { post in
                                NavigationLink(destination: PostDetailView(post: post, viewModel: viewModel)) {
                                    GamePostCard(
                                        post: post,
                                        isFavorite: viewModel.isFavorite(postId: post.id),
                                        toggleFavorite: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                viewModel.toggleFavorite(postId: post.id)
                                            }
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 100)
                    }
                    .refreshable {
                        await viewModel.fetchPosts()
                    }
                }
            }
        }
        .task {
            if viewModel.posts.isEmpty {
                await viewModel.fetchPosts()
            }
        }
    }
}

struct GameHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color.theme.textPrimary)
                .shadow(color: Color.theme.primaryOrange.opacity(0.3), radius: 10)
            
            Spacer()
            
            // Stats badge
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(Color.theme.primaryOrange)
                Text("100")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.textPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.primaryOrange.opacity(0.3), radius: 5)
            )
        }
        .padding(.horizontal, 20)
    }
}

struct GameSearchBar: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.primaryOrange)
                .font(.system(size: 18, weight: .semibold))
            
            TextField("Search battles...", text: $searchText)
                .foregroundColor(Color.theme.textPrimary)
                .font(.system(size: 16, weight: .medium))
                .accentColor(Color.theme.primaryOrange)
                .onTapGesture {
                    isEditing = true
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.textSecondary)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: isEditing ? [Color.theme.primaryOrange, Color.theme.secondaryOrange] : [Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: isEditing ? Color.theme.primaryOrange.opacity(0.3) : Color.clear, radius: 10)
        )
    }
}

struct GamePostCard: View {
    let post: Post
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank badge
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.primaryOrange, Color.theme.secondaryOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text("#\(post.id)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: Color.theme.primaryOrange.opacity(0.4), radius: 8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(post.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color.theme.primaryOrange)
                    
                    Text("Player \(post.userId)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.theme.textSecondary)
                }
            }
            
            Spacer()
            
            // Favorite button
            Button(action: {
                toggleFavorite()
            }) {
                ZStack {
                    Circle()
                        .fill(isFavorite ? Color.theme.primaryOrange.opacity(0.2) : Color.theme.cardBackground)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? Color.theme.primaryOrange : Color.theme.textSecondary)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.theme.primaryOrange.opacity(0.3), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.theme.shadowColor, radius: 10, y: 5)
        )
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

struct GameLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.theme.cardBackground, lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [Color.theme.primaryOrange, Color.theme.secondaryOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            .onAppear {
                isAnimating = true
            }
            
            Text("Loading Battle Data...")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.theme.textSecondary)
        }
    }
}

struct GameErrorView: View {
    let errorMessage: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.theme.cardBackground)
                    .frame(width: 100, height: 100)
                    .shadow(color: Color.red.opacity(0.3), radius: 15)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 8) {
                Text("Battle Failed!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.theme.textPrimary)
                
                Text(errorMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: retry) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .bold))
                    Text("Retry Battle")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color.theme.primaryOrange, Color.theme.secondaryOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color.theme.primaryOrange.opacity(0.5), radius: 15, y: 5)
            }
        }
    }
}

