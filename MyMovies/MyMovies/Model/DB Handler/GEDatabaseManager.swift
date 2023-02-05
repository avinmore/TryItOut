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
        default:
            print("It's something else")
        }
    }
    
}
