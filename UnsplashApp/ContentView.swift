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
    // Déclaration d'une variable d'état, une fois remplie, elle va modifier la vue
    @State var imageList: [UnsplashPhoto] = []
    
    // Déclaration d'une fonction asynchrone
        func loadData() async {
            // Créez une URL avec la clé d'API
            let url = URL(string: "https://api.unsplash.com/photos?client_id=\(ConfigurationManager.instance.plistDictionnary.clientId)")!

            do {
                // Créez une requête avec cette URL
                let request = URLRequest(url: url)
                
                // Faites l'appel réseau
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Transformez les données en JSON
                let deserializedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)

                // Mettez à jour l'état de la vue
                imageList = deserializedData

            } catch {
                print("Error: \(error)")
            }
        }
    
    let columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack{
            VStack {
                // le bouton va lancer l'appel réseau
                Button(action: {
                    Task {
                        await loadData()
                    }
                }, label: {
                    Text("Load Data")
                })
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(imageList) { unsplashPhoto in
                            AsyncImage(url: URL(string: unsplashPhoto.urls.regular)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 150)
                            .cornerRadius(12)
                        }
                        
                    }
                    
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
