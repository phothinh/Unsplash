//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Henri Phothinantha on 02/02/2024.
//

import SwiftUI

// MARK: - WelcomeElement
struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let slug: String
    let urls: UnsplashPhotoUrls
    let user: User
}

// MARK: - Urls
struct UnsplashPhotoUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

// MARK: - User
struct User: Codable {
    let name: String
}

typealias Photo = [UnsplashPhoto]


// MARK: - ContentView
struct ContentView: View {

    let columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]
    
    @StateObject var feedState = FeedState()
    
    var body: some View {
        NavigationStack{
            VStack {
                // le bouton va lancer l'appel réseau
                Button(action: {
                    Task {
                        await feedState.fetchHomeFeed()
                    }
                }, label: {
                    Text("Load Data")
                })
                
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        if let homeFeed = feedState.homeFeed {
                            ForEach(homeFeed) { unsplashPhoto in
                                AsyncImage(url: URL(string: unsplashPhoto.urls.regular)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 150)
                                .cornerRadius(12)
                            }
                        } else {
                            ForEach(0..<12) { _ in
                                Rectangle()
                                    .foregroundColor(Color.gray.opacity(0.3))
                                    .cornerRadius(12)
                                    .frame(height: 150)
                            }
                        }
                    }
                    .redacted(reason: feedState.homeFeed == nil ? .placeholder : [])
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .navigationTitle("Feed")
                .padding(.horizontal)
            }
        }
    }
        
}

#Preview {
    ContentView()
}
