//
//  CustomTabBar.swift
//  Battlebucks
//
//  Created by Abid on 10/22/2025.
//

import SwiftUI

enum TabItem: Int, CaseIterable {
    case posts = 0
    case favorites = 1
    
    var icon: String {
        switch self {
        case .posts: return "list.bullet.rectangle.portrait.fill"
        case .favorites: return "heart.fill"
        }
    }
    
    var title: String {
        switch self {
        case .posts: return "Posts"
        case .favorites: return "Favorites"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            Color.theme.cardBackground
                .overlay(
                    LinearGradient(
                        colors: [Color.theme.primaryOrange.opacity(0.1), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: Color.theme.primaryOrange.opacity(0.2), radius: 20, y: -5)
            
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    if tab.rawValue == 0 {
                        TabBarButton(tab: tab, selectedTab: $selectedTab, animation: animation)
                        
                        Spacer()
                        
                        // Main Aura Farming Button
                        CenterTabButton(selectedTab: $selectedTab)
                        
                        Spacer()
                    } else {
                        TabBarButton(tab: tab, selectedTab: $selectedTab, animation: animation)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .frame(height: 80)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    @Binding var selectedTab: TabItem
    let animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? Color.theme.primaryOrange : Color.theme.textSecondary)
                    .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? Color.theme.primaryOrange : Color.theme.textSecondary)
                
                if selectedTab == tab {
                    Circle()
                        .fill(Color.theme.primaryOrange)
                        .frame(width: 5, height: 5)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct CenterTabButton: View {
    @Binding var selectedTab: TabItem
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selectedTab = .posts
            }
        }) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.theme.primaryOrange.opacity(0.4), Color.clear],
                            center: .center,
                            startRadius: 30,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: 10)
                
                // Main button background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.primaryOrange, Color.theme.secondaryOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: Color.theme.primaryOrange.opacity(0.6), radius: 15, y: 5)
                
                // Inner design
                Image(systemName: "house.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                // Border ring
                Circle()
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 2)
                    .frame(width: 70, height: 70)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .offset(y: -30)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    ZStack {
        Color.theme.background
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.posts))
        }
    }
}

