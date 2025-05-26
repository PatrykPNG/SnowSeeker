//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Patryk Ostrowski on 05/05/2025.
//

import SwiftUI

enum SortType {
    case `default`, alphabetical, country
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var favorites = Favorites()
    @State private var searchText = ""
    
    @State private var sortType = SortType.default
    @State private var showingSortOption = false
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            resorts
        } else {
            resorts.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var sortedResorts: [Resort] {
        switch sortType {
        case .default:
            filteredResorts
        case .alphabetical:
            filteredResorts.sorted { $0.name < $1.name}
        case .country:
            filteredResorts.sorted { $0.country < $1.country}
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(sortedResorts) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 24)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("sort type", systemImage: "arrow.up.arrow.down") {
                        showingSortOption = true
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .confirmationDialog("Change sorting type", isPresented: $showingSortOption) {
                Button("Deafult") {
                    sortType = .default
                }
                
                Button("alphabetical") {
                    sortType = .alphabetical
                }
                
                Button("country") {
                    sortType = .country
                }//tutaj sort type zmieaniamy a potem nna gorze robimy var sortedResorts: [Resort] { switch sortype case }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
