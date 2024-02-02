//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Henri Phothinantha on 02/02/2024.
//

import SwiftUI

// MARK: - UnsplashPhoto

struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let slug: String
    let urls: UnsplashPhotoUrls
    let user: User
//    let topicSubmissions: TopicSubmissions
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case slug
//        case urls
//        case topicSubmissions = "topic_submissions"
//        case user
//    }
}

//// MARK: - TopicSubmissions
//
//struct TopicSubmissions: Codable {
//    let film : Topic?
//    let streetPhotography : Topic?
//    let architectureInterior: Topic?
//    let travel: Topic?
//
//    enum CodingKeys: String, CodingKey {
//        case film
//        case streetPhotography = "street-photography"
//        case architectureInterior = "architecture-interior"
//        case travel
//    }
//}


//// MARK: - Topic
//
//struct Topic: Codable {
//    let status: String
//}

// MARK: - CoverPhoto

struct UnsplashTopic: Codable, Identifiable {
    let id, title: String
    let coverPhoto: CoverPhoto

    enum CodingKeys: String, CodingKey {
        case id, title
        case coverPhoto = "cover_photo"
    }
}

// MARK: - CoverPhoto

struct CoverPhoto: Codable {
    let urls: UnsplashPhotoUrls
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
        GridItem(.flexible(minimum: 150)),
    ]
    
    @StateObject var feedState = FeedState()
    
    var body: some View {
        NavigationStack{
            VStack {
                
                Button(action: {
                    Task {
                        await feedState.fetchHomeFeed()
                    }
                }, label: {
                    Text("Load Data")
                })
                
                ScrollView(.horizontal) {
                    HStack {
                        
                        
                        if let homeTopic = feedState.homeTopic {
                            ForEach(homeTopic) { unsplashTopic in
                                AsyncImage(url: URL(string: unsplashTopic.coverPhoto.urls.regular)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 60)
                                .cornerRadius(12)
                            }
                        } else {
                            ForEach(0..<6) { _ in
                                Rectangle()
                                    .foregroundColor(Color.gray.opacity(0.3))
                                    .cornerRadius(12)
                                    .frame(width: 100, height: 60)
                            }
                        }
                        
                        
                    }
                    .padding()
                }
                
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
