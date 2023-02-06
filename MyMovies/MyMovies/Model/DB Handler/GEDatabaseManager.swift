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
    
    func saveData<T: Codable>(_ response: T) {
        switch response {
        case let movies as Movies:
            GEDatabaseWorker.shared.saveMovies(movies)
        case let genres as GEGenreModel:
            GEDatabaseWorker.shared.saveGenre(genres)
        case let movieDetails as GEMovieDetailModel:
            GEDatabaseWorker.shared.saveMovieDetails(movieDetails)
        default:
            
            print("It's something else")
        }
    }
    
    func updateFavoriteStatus(_ id: Int) -> FavoriteStatus {
        GEDatabaseWorker.shared.updateFavoriteStatus(id)
    }
    
    func fetchAllfavoritesMovies() -> [GEMovie] {
        return GEDatabaseWorker.shared.fetchAllfavoritesMovies().map({ $0.toCGMovie() })
    }
}
