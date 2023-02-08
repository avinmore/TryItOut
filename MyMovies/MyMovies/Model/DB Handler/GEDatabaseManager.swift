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
    
    func saveData<T: Codable>(_ response: T, category: String, completion:  @escaping () -> Void) {
        switch response {
        case let movies as Movies:
            GEDatabaseWorker.shared.saveMovies(movies, category: category, completion: completion)
        case let genres as GEGenreModel:
            GEDatabaseWorker.shared.saveGenre(genres, completion: completion)
        case let movieDetails as GEMovieDetailModel:
            GEDatabaseWorker.shared.saveMovieDetails(movieDetails, completion: completion)
        default:
            print("It's something else")
        }
    }
    
    func updateFavoriteStatus(_ id: Int) -> FavoriteStatus {
        GEDatabaseWorker.shared.updateFavoriteStatus(id)
    }
    
    func fetchAllfavoritesMovies(completion: @escaping ([GEMovie]) -> Void) {
        GEDatabaseWorker.shared.fetchAllfavoritesMovies { movies in
            completion(movies.map({ $0.toCGMovie() }))
        }
    }
    
    func fetchMoviesByCategoriesWith(_ category: String, completion: @escaping ([GEMovie]) -> Void) {
        GEDatabaseWorker.shared.fetchMoviesByCategoriesWith(category: category) { movies in
            completion(movies.map({ $0.toCGMovie() }))
        }
    }
    
    func fetchAllMoviesWithQuery(_ query: String, completion: @escaping ([GEMovie]) -> Void) {
        GEDatabaseWorker.shared.fetchMoviesQuery(query) { movies in
            completion(movies.map({ $0.toCGMovie() }))
        }
    }
}
