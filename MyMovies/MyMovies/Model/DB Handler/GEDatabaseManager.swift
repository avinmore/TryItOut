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
    let databaseQueue = DispatchQueue(label: "com.myapp.databaseQueue", qos: .utility)

    func saveData<T: Codable>(_ response: T, category: String) {
        databaseQueue.async {
            switch response {
            case let movies as Movies:
                GEDatabaseWorker.shared.saveMovies(movies, category: category)
            case let genres as GEGenreModel:
                GEDatabaseWorker.shared.saveGenre(genres)
            case let movieDetails as GEMovieDetailModel:
                GEDatabaseWorker.shared.saveMovieDetails(movieDetails)
            default:
                
                print("It's something else")
            }
        }
    }
    
    func updateFavoriteStatus(_ id: Int) -> FavoriteStatus {
        GEDatabaseWorker.shared.updateFavoriteStatus(id)
    }
    
    func fetchAllfavoritesMovies() -> [GEMovie] {
        return GEDatabaseWorker.shared.fetchAllfavoritesMovies().map({ $0.toCGMovie() })
    }
    
    func fetchAllMoviesWith(_ category: String) -> [GEMovie] {
        return GEDatabaseWorker.shared.fetchMoviesByCategories(category: category).map({ $0.toCGMovie() })
    }
    
}
