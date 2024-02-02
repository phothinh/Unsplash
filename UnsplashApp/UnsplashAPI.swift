//
//  UnsplashAPI.swift
//  UnsplashApp
//
//  Created by Henri Phothinantha on 02/02/2024.
//

import Foundation

struct UnsplashAPI {
    private static let scheme = "https"
    private static let host = "api.unsplash.com"
    private static let path = "/"
    private static let clientId = ConfigurationManager.instance.plistDictionnary.clientId
    
    static var unsplashApiBaseUrl: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem(name: "client_id", value: clientId)]
        return components
    }

    static func feedUrl(orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl
        components.path += "/photos"
        
        let queryParams: [URLQueryItem] = [
            URLQueryItem(name: "order_by", value: orderBy),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        components.queryItems?.append(contentsOf: queryParams)
        
        return components.url
    }
}

