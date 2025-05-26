//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Patryk Ostrowski on 12/05/2025.
//

import SwiftUI

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"
    
    init() {
        resorts = []
        
        loadData()
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    //resorts = Set(tutajarrayzapisanych)
    
    func save() {
        let path = URL.documentsDirectory.appending(component: "resorts")
        let resortsArray = Array(resorts)
        let data = try? JSONEncoder().encode(resortsArray)
        
        do {
            try data?.write(to: path)
            print("zapisuje \(resortsArray)")
            print("zapisuje \(String(describing: data))")
        } catch {
            print("😡 \(error.localizedDescription)")
        }
    }
    
    func loadData() {
        let path = URL.documentsDirectory.appending(component: "resorts")
        guard let data = try? Data(contentsOf: path) else { return }
        do {
            let resortsArray = try JSONDecoder().decode([String].self, from: data)
            resorts = Set(resortsArray)
            print("wczytuje \(resorts)")
            print("wczytywanie jest resortow \(resorts.count)")
        } catch {
            print("😡 \(error.localizedDescription)")
        }
    }
}
