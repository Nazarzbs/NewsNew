//
//  NewsCardView.swift
//  NewNews
//
//  Created by nazar on 30.10.2025.
//

import SwiftUI

struct NewsCardView: View {
    let article: Article
    @State private var retryCount = 0
    private let maxRetries = 3
    
    var body: some View {
        GeometryReader { geometry in
            let imageWidth = geometry.size.width

            VStack(alignment: .leading, spacing: 8) {
                // Image
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: imageWidth, height: 200)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageWidth, height: 200)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .onAppear {
                                    // Reset retry count on success
                                    retryCount = 0
                                }
                        case .failure(let error):
                            ZStack {
                                ProgressView()
                                    .frame(width: imageWidth, height: 200)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .frame(width: imageWidth, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .onAppear {
                                print("Failed to load image from \(imageUrl)")
                                print("Error: \(error.localizedDescription)")
                                print("Retry count: \(retryCount)")
                                
                                // Auto-retry once after 1 second
                                if retryCount == 0 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        retryCount += 1
                                    }
                                }
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .id("\(url.absoluteString)-\(retryCount)")
                } else {
                    ZStack {
                        Color.gray.opacity(0.3)
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    .frame(width: imageWidth, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)

                    if let description = article.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 12)
            }
            .frame(width: geometry.size.width)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5)
            )
        }
        .frame(height: 330)
        .id(article.id)
    }
}
