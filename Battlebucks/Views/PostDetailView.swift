//
//  PostDetailView.swift
//  Battlebucks
//
//  Created by Abid on 10/22/2025.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @ObservedObject var viewModel: PostsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.background, Color.theme.cardBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    BattleHeaderCard(post: post)
                        .padding(.top, 20)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -20)
                    
                    // Stats Section
                    BattleStatsSection(post: post)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -20)
                    
                    // Content Card
                    BattleContentCard(content: post.body)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    BattleActionButtons(
                        isFavorite: viewModel.isFavorite(postId: post.id),
                        toggleFavorite: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                viewModel.toggleFavorite(postId: post.id)
                            }
                        }
                    )
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color.theme.primaryOrange)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

struct BattleHeaderCard: View {
    let post: Post
    
    var body: some View {
        VStack(spacing: 16) {
            // Rank Badge
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.primaryOrange, Color.theme.secondaryOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.theme.primaryOrange.opacity(0.5), radius: 20, y: 5)
                
                VStack(spacing: 2) {
                    Text("RANK")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                    Text("#\(post.id)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Text(post.title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(Color.theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .shadow(color: Color.theme.primaryOrange.opacity(0.2), radius: 5)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [Color.theme.primaryOrange.opacity(0.5), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.theme.shadowColor, radius: 15, y: 8)
        )
    }
}

struct BattleStatsSection: View {
    let post: Post
    
    var body: some View {
        HStack(spacing: 16) {
            StatBox(icon: "person.fill", value: "\(post.userId)", label: "Player")
            StatBox(icon: "flame.fill", value: "100", label: "Power")
            StatBox(icon: "star.fill", value: "5.0", label: "Rating")
        }
    }
}

struct StatBox: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.theme.primaryOrange)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.theme.textPrimary)
            
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color.theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardBackground)
                .shadow(color: Color.theme.shadowColor, radius: 8, y: 4)
        )
    }
}

struct BattleContentCard: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(Color.theme.primaryOrange)
                    .font(.system(size: 16, weight: .semibold))
                
                Text("Battle Description")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.textPrimary)
                
                Spacer()
            }
            
            Text(content)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.theme.textSecondary)
                .lineSpacing(6)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.theme.primaryOrange.opacity(0.2), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.theme.shadowColor, radius: 10, y: 5)
        )
    }
}

struct BattleActionButtons: View {
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    @State private var isPressedFav = false
    @State private var isPressedShare = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Favorite Button
            Button(action: toggleFavorite) {
                HStack(spacing: 12) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text(isFavorite ? "Favorited" : "Add to Favorites")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: isFavorite 
                                    ? [Color.theme.primaryOrange, Color.theme.secondaryOrange]
                                    : [Color.theme.cardBackground, Color.theme.cardBackground],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.theme.primaryOrange, lineWidth: isFavorite ? 0 : 2)
                        )
                        .shadow(color: isFavorite ? Color.theme.primaryOrange.opacity(0.5) : Color.clear, radius: 15, y: 5)
                )
                .scaleEffect(isPressedFav ? 0.95 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressedFav = pressing
                }
            }, perform: {})
            
            // Share Button
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.theme.primaryOrange)
                    .frame(width: 56, height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.theme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.theme.primaryOrange, lineWidth: 2)
                            )
                    )
                    .scaleEffect(isPressedShare ? 0.95 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressedShare = pressing
                }
            }, perform: {})
        }
    }
}

