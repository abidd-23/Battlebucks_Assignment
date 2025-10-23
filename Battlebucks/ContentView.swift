//
//  ContentView.swift
//  Battlebucks
//
//  Created by Syed Abid Mustafa on 10/22/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PostsViewModel()
    @State private var selectedTab: TabItem = .posts
    
    var body: some View {
        ZStack {
            // Background
            Color.theme.background
                .ignoresSafeArea()
            
            // Tab bar content
            VStack(spacing: 0) {
                TabContent(selectedTab: $selectedTab, viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct TabContent: View {
    @Binding var selectedTab: TabItem
    @ObservedObject var viewModel: PostsViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch selectedTab {
                case .posts:
                    PostsListView(viewModel: viewModel)
                case .favorites:
                    FavoritesView(viewModel: viewModel)
                }
            }
        }
        .id(selectedTab)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
    }
}

#Preview {
    ContentView()
}
