//
//  NewsAPIService.swift
//  NewNews
//
//  Created by nazar on 30.10.2025.
//

import Foundation
import CryptoKit

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Int)
    case decodingFailed
    case missingAPIKey

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let code): return "Request failed with code: \(code)"
        case .decodingFailed: return "Failed to decode server response"
        case .missingAPIKey: return "API key is missing"
        }
    }
}

final class NewsAPIService {
    func fetchArticles(query: String?) async throws -> [Article] {
        guard Constants.apiKey.isEmpty == false, Constants.apiKey != "YOUR_NEWSAPI_KEY" else {
            throw NetworkError.missingAPIKey
        }

        var components = URLComponents(url: Constants.baseURL.appendingPathComponent("everything"), resolvingAgainstBaseURL: false)
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: Constants.apiKey),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "pageSize", value: "50")
        ]
        if let q = query, q.isEmpty == false {
            queryItems.append(URLQueryItem(name: "q", value: q))
        } else {
            // Fallback to top headlines if no query
            components = URLComponents(url: Constants.baseURL.appendingPathComponent("top-headlines"), resolvingAgainstBaseURL: false)
            queryItems = [
                URLQueryItem(name: "apiKey", value: Constants.apiKey),
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "pageSize", value: "50")
            ]
        }
        components?.queryItems = queryItems

        guard let url = components?.url else { throw NetworkError.invalidURL }
        let cacheKey = cacheKey(for: url)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) == false {
                throw NetworkError.requestFailed(http.statusCode)
            }

            let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
            // Cache on success
            try await CacheService.shared.cache(decoded.articles, forKey: cacheKey)
            return decoded.articles
        } catch {
            // On failure, attempt to use cached data
            if let cached: [Article] = try? await CacheService.shared.retrieve(forKey: cacheKey) {
                return cached
            }
            // If no cache, rethrow meaningful error
            if let urlError = error as? URLError {
                throw urlError
            }
            if let decodingError = error as? DecodingError {
                throw decodingError
            }
            throw error
        }
    }

    private func cacheKey(for url: URL) -> String {
        let data = Data(url.absoluteString.utf8)
        let digest = SHA256.hash(data: data)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}


