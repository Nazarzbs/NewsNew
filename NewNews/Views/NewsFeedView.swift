//
//  NewsFeedView.swift
//  NewNews
//
//  Created by nazar on 30.10.2025.
//

import SwiftUI

struct NewsFeedView: View {
    @State private var viewModel = NewsViewModel()
    @State private var searchTask: Task<Void, Never>? = nil
    @State private var isSearchPresented: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let message = viewModel.errorMessage {
                    ContentUnavailableView(message, systemImage: "wifi.slash")
                } else if viewModel.articles.isEmpty {
                    ContentUnavailableView("No news yet", systemImage: "newspaper")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.articles) { article in
                                if article.urlToImage != nil {
                                NavigationLink(value: article) {
                                  
                                        NewsCardView(article: article)
                                    
                                }
                                .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .scrollIndicators(.hidden)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationDestination(for: Article.self) { article in
                NewsDetailView(article: article)
            }
            .navigationTitle("News")
        }
        .searchable(text: $viewModel.searchText, isPresented: $isSearchPresented, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("Search news, for example: 'Ukraine'"))
        .onSubmit(of: .search) {
            searchTask?.cancel()
            searchTask = Task { await viewModel.searchNews() }
        }
        .onChange(of: isSearchPresented) { _, presented in
            if presented == false {
                viewModel.searchText = ""
                Task { await viewModel.loadNews(query: nil) }
            }
        }
        .task {
            await viewModel.loadNews(query: nil)
        }
        .refreshable {
            await viewModel.loadNews(query: viewModel.searchText)
        }
    }
}

#Preview {
    NewsFeedView()
}


