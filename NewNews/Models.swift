//
//  NewsResponse.swift
//  NewNews
//
//  Created by nazar on 30.10.2025.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Identifiable, Codable, Hashable {
    let id: UUID = UUID()
    let title: String
    let description: String?
    let urlToImage: String?
    let url: String

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlToImage
        case url
    }
}


