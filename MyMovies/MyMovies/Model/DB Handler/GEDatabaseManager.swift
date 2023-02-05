//
//  GEDatabaseManager.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
class GEDatabaseManager {
    static let shared = GEDatabaseManager()
    private init() {}
    private var genres: [Genres] = []
    
    func saveData<T: Codable>(_ response: T) {
        switch response {
        case let movies as Movies:
            GEDatabaseWorker.shared.saveMovies(movies)
        case let genres as GEGenreModel:
            GEDatabaseWorker.shared.saveGenre(genres)
            GEDatabaseManager.shared.genres = GEDatabaseWorker.shared.fetchGenre().map { $0.toGenre() }
        default:
            print("It's something else")
        }
    }
    
    func fetchGenreFor(_ id: Int) -> String {
        return GEDatabaseManager.shared.genres.first(where: { $0.id == id })?.name ?? ""
    }
    
    
}
