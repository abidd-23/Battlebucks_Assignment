//
//  FavoritesView.swift
//  Battlebucks
//
//  Created by Abid on 10/22/2025.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PostsViewModel
    @State private var showFavorites = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.theme.background, Color.theme.cardBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                FavoritesHeaderView(count: viewModel.favorites.count)
                    .padding(.top, 10)
                
                if viewModel.favorites.isEmpty {
                    Spacer()
                    EmptyFavoritesView()
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.favorites.enumerated()), id: \.element.id) { index, post in
                                NavigationLink(destination: PostDetailView(post: post, viewModel: viewModel)) {
                                    FavoritePostCard(
                                        post: post,
                                        index: index,
                                        removeFavorite: {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                                viewModel.toggleFavorite(postId: post.id)
                                            }
                                        }
                                    )
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    ))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showFavorites = true
            }
        }
    }
}

struct FavoritesHeaderView: View {
    let count: Int
    @State private var pulseAnimation = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Favorites")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.textPrimary)
                    .shadow(color: Color.theme.primaryOrange.opacity(0.3), radius: 10)
                
                Text("\(count) Battle\(count != 1 ? "s" : "") Saved")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            Spacer()
            
            // Favorite badge with animation
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.theme.primaryOrange.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                    .opacity(pulseAnimation ? 0 : 1)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.primaryOrange, Color.theme.secondaryOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.theme.primaryOrange.opacity(0.5), radius: 15)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .onAppear {
                withAnimation(
                    Animation.easeOut(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    pulseAnimation = true
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct EmptyFavoritesView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 28) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.theme.primaryOrange.opacity(0.2), Color.clear],
                            center: .center,
                            startRadius: 60,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .opacity(isAnimating ? 0.5 : 1)
                
                Circle()
                    .fill(Color.theme.cardBackground)
                    .frame(width: 140, height: 140)
                    .shadow(color: Color.theme.shadowColor, radius: 20, y: 10)
                
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color.theme.textSecondary)
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
            }
            
            VStack(spacing: 12) {
                Text("No Favorites Yet")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.textPrimary)
                
                Text("Start adding battles to your favorites\nby tapping the heart icon")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            HStack(spacing: 20) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.theme.primaryOrange.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.3 : 0.7)
                        .animation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
            .padding(.top, 10)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct FavoritePostCard: View {
    let post: Post
    let index: Int
    let removeFavorite: () -> Void
    @State private var isPressed = false
    @State private var showRemove = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.primaryOrange, Color.theme.secondaryOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.theme.primaryOrange.opacity(0.5), radius: 10)
                
                VStack(spacing: 2) {
                    Image(systemName: getTrophyIcon(index: index))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("#\(post.id)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 12) {
                    Label {
                        Text("Player \(post.userId)")
                            .font(.system(size: 13, weight: .semibold))
                    } icon: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(Color.theme.textSecondary)
                    
                    Label {
                        Text("Favorite")
                            .font(.system(size: 13, weight: .semibold))
                    } icon: {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(Color.theme.primaryOrange)
                }
            }
            
            Spacer()
            
            // Remove button
            Button(action: {
                removeFavorite()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.theme.primaryOrange)
                    .background(
                        Circle()
                            .fill(Color.theme.cardBackground)
                            .frame(width: 32, height: 32)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.theme.primaryOrange.opacity(0.4), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.theme.shadowColor, radius: 12, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.theme.primaryOrange, lineWidth: 2)
                        .opacity(isPressed ? 0.5 : 0)
                )
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
    
    private func getTrophyIcon(index: Int) -> String {
        switch index {
        case 0: return "trophy.fill"
        case 1: return "medal.fill"
        case 2: return "star.fill"
        default: return "heart.fill"
        }
    }
}

