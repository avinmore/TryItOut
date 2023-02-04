//
//  GEDatabaseWorker.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//
import Foundation
import UIKit
import CoreData
class GEDatabaseWorker {
    static let shared = GEDatabaseWorker()
    private init() {}
    var managedContext: NSManagedObjectContext?
    
    func saveMovies(_ movies: Movies) {
        guard let context = GEDatabaseWorker.shared.managedContext else { return }
        
        for movie in movies.results {
            let manageObject = Movie(context: context)
            manageObject.genre_ids = movie.genreIDS.data
            manageObject.id = Int64(movie.id)
            manageObject.original_language = movie.originalLanguage
            manageObject.adult = movie.adult
            manageObject.original_title = movie.originalTitle
            manageObject.overview = movie.overview
            manageObject.popularity = movie.popularity
            manageObject.poster_path = movie.posterPath
            manageObject.release_date = movie.releaseDate
            manageObject.title = movie.title
            manageObject.video = movie.video
            manageObject.vote_average = movie.voteAverage
            manageObject.vote_count = Int16(movie.voteCount)
        }
        saveData(context)
    }
    
    
    
    func saveGenre(_ genres: GEGenreModel) {
        guard let context = GEDatabaseWorker.shared.managedContext else { return }
        for genre in genres.genres {
            let manageObject = Genre(context: context)
            manageObject.id = Int16(genre.id)
            manageObject.name = genre.name
        }
        saveData(context)
    }
    
    func fetchMovies() {
        guard let context = GEDatabaseWorker.shared.managedContext else { return }
        let fetchMoviesRequest = Movie.fetchRequest()
        do {
            let movies = try context.fetch(fetchMoviesRequest)
           
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchGenre() {
        guard let context = GEDatabaseWorker.shared.managedContext else { return }
        let fetchGenreRequest = Genre.fetchRequest()
        do {
            let genres = try context.fetch(fetchGenreRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

//Helpers
extension ContiguousBytes {
    func objects<T>() -> [T] { withUnsafeBytes { .init($0.bindMemory(to: T.self)) } }
    var dataToInt: [Int] { objects() }
}

extension Array {
    var data: Data { withUnsafeBytes { .init($0) } }
}
