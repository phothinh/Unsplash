//
//  FeedState.swift
//  UnsplashApp
//
//  Created by Henri Phothinantha on 02/02/2024.
//

import Foundation

class FeedState: ObservableObject {
    @Published var homeFeed: [UnsplashPhoto]?
    @Published var homeTopic: [UnsplashTopic]?

    func fetchHomeFeed() async {
        do {
            guard let url = UnsplashAPI.feedUrl() else {
                print("Error: Invalid URL for home feed")
                return
            }

            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)

            homeFeed = decodedData
        } catch {
            print("Error fetching home feed: \(error)")
        }
    }
    
    func fetchHomeTopic() async {
        do {
            guard let url = UnsplashAPI.topicUrl() else {
                print("Error: Invalid URL for home feed")
                return
            }

            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode([UnsplashTopic].self, from: data)

            homeTopic = decodedData
        } catch {
            print("Error fetching home feed: \(error)")
        }
    }
}

