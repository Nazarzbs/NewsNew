//
//  NewsViewModel.swift
//  NewNews
//
//  Created by nazar on 30.10.2025.
//

import Foundation
import Observation

@Observable
final class NewsViewModel {
    var articles: [Article] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var searchText: String = ""

    private let service: NewsAPIService

    init(service: NewsAPIService = NewsAPIService()) {
        self.service = service
    }

    @MainActor
    func loadNews(query: String?) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await service.fetchArticles(query: query)
            articles = result
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            articles = []
        }
        isLoading = false
    }

    @MainActor
    func searchNews() async {
        await loadNews(query: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}


