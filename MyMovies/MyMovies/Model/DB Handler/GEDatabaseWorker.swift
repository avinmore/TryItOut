//
//  GEDatabaseWorker.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//
import Foundation
import UIKit
import CoreData

enum FavoriteStatus {
    case favorite
    case yetToFavorite
    case na
}

class GEDatabaseWorker {
    static let shared = GEDatabaseWorker()
    private init() {}
    var managedContext: NSManagedObjectContext?
    private var genres: [Genres] = []
    func saveMovies(_ movies: Movies) {
        guard let context = GEDatabaseWorker.shared.managedContext else { return }
        genres = GEDatabaseWorker.shared.fetchGenre().map { $0.toGenre() }
        for movie in movies.results {
            var manageObject = Movie(context: context)
            //check exists
//            let fetchMoviesRequest = Movie.fetchRequest()
//            fetchMoviesRequest.predicate = NSPredicate(format: "id == \(movie.id)")
//            fetchMoviesRequest.fetchLimit = 1
//            if let count = try? context.count(for: fetchMoviesRequest),
//               count == 1,
//                let movies = try? context.fetch(fetchMoviesRequest),
//                let existingMovie = movies.first {
//                manageObject = existingMovie
//            }
            manageObject.genre_ids = movie.genreIDS?.data
            manageObject.id = Int64(movie.id)
            manageObject.original_language = movie.originalLanguage
            manageObject.adult = movie.adult
            manageObject.original_title = movie.originalTitle
            manageObject.overview = movie.overview
            manageObject.popularity = movie.popularity ?? 0
            manageObject.poster_path = movie.posterPath
            manageObject.release_date = movie.releaseDate
            manageObject.title = movie.title
            manageObject.video = movie.video ?? false
            manageObject.vote_average = movie.voteAverage ?? 0
            manageObject.vote_count = Int64(movie.voteCount ?? 0)
            manageObject.dateAdded = Date()
            manageObject.genre_list = movie.genreIDS?.map { fetchGenreFor($0) }.joined(separator: " * ")
        }
        saveData(context)
    }
    
    func fetchGenreFor(_ id: Int) -> String {
        return genres.first(where: { $0.id == id })?.name ?? ""
    }
    
    func saveMovieDetails(_ movieDetail: GEMovieDetailModel) {
        guard let context = GEDatabaseWorker.shared.managedContext else { return }
        let fetchMoviesRequest = MovieDetail.fetchRequest()
        var manageObject = MovieDetail(context: context)
        if let movieId = movieDetail.id {
            fetchMoviesRequest.predicate = NSPredicate(format: "id == \(movieId)")
            do {
                let movies = try context.fetch(fetchMoviesRequest)
                if let movieDet = movies.first {
                    manageObject = movieDet
                }
            } catch {
                // print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        }
        
        manageObject.adult = movieDetail.adult ?? true
        manageObject.backdrop_path = movieDetail.backdropPath
        manageObject.budget = Int64(movieDetail.budget ?? 0)
        manageObject.genres = try? JSONEncoder().encode(movieDetail.genres)
        manageObject.homepage = movieDetail.homepage
        manageObject.id = Int64(movieDetail.id ?? 0)
        manageObject.imdb_id = movieDetail.imdbID
        manageObject.original_language = movieDetail.originalLanguage
        manageObject.original_title = movieDetail.originalTitle
        manageObject.overview = movieDetail.overview
        manageObject.popularity = movieDetail.popularity ?? 0
        manageObject.poster_path = movieDetail.posterPath
        manageObject.release_date = movieDetail.releaseDate
        manageObject.revenue = Int64(movieDetail.revenue ?? 0)
        manageObject.runtime = Int64(movieDetail.runtime ?? 0)
        manageObject.spoken_languages = try? JSONEncoder().encode(movieDetail.spokenLanguages)
        manageObject.status = movieDetail.status
        manageObject.tagline = movieDetail.tagline
        manageObject.title = movieDetail.title
        manageObject.video = movieDetail.video ?? false
        manageObject.vote_average = movieDetail.voteAverage ?? 0
        manageObject.vote_count = Int64(movieDetail.voteCount ?? 0)
        saveData(context)
    }
    func saveGenre(_ genres: GEGenreModel) {
        guard let context = GEDatabaseWorker.shared.managedContext else { return }
        for genre in genres.genres {
            let manageObject = Genre(context: context)
            manageObject.id = Int64(genre.id)
            manageObject.name = genre.name
        }
        saveData(context)
    }
    
    func updateFavoriteStatus(_ id: Int) -> FavoriteStatus  {
        //update favorite table
        guard let context = GEDatabaseWorker.shared.managedContext else { return .na }
        let fetchMoviesRequest = FavoriteMovies.fetchRequest()
        fetchMoviesRequest.predicate = NSPredicate(format: "id == \(id)")
        var status = FavoriteStatus.yetToFavorite
        do {
            let movies = try context.fetch(fetchMoviesRequest)
            if let movieDet = movies.first {
                context.delete(movieDet)
            } else {
                let manageObject = FavoriteMovies(context: context)
                manageObject.id = Int64(id)
                status = .favorite
            }
        } catch  {
            // print("Could not fetch. \(error), \(error.userInfo)")
        }
        saveData(context)
        return status
    }
    
    func fetchAllfavoritesMovies() -> [Movie] {
        guard let context = GEDatabaseWorker.shared.managedContext else { return [] }
        let fetchMoviesRequest = FavoriteMovies.fetchRequest()
        do {
            let allfavoriteMovieIds = try context.fetch(fetchMoviesRequest)
            return fetchfavoriteMovies( allfavoriteMovieIds.map({ Int($0.id) }))
        } catch  {
            // print("Could not fetch. \(error), \(error.userInfo)")
        }
        return  []
    }
    
    func fetchfavoriteMovies(_ ids: [Int]) -> [Movie] {
        guard let context = GEDatabaseWorker.shared.managedContext else { return [] }
        let fetchMoviesRequest = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id IN %@", ids)
        fetchMoviesRequest.predicate = predicate
        do {
            let movies = try context.fetch(fetchMoviesRequest)
            return movies
        } catch {
            // print("Could not fetch. \(error), \(error.userInfo)")
        }
        return  []
    }
    
    
//    func fetchMovies() {
//        guard let context = GEDatabaseWorker.shared.managedContext else { return }
//        let fetchMoviesRequest = Movie.fetchRequest()
//        do {
//            let movies = try context.fetch(fetchMoviesRequest)
//
//        } catch let error as NSError {
////            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
    
    func fetchGenre() -> [Genre] {
        guard let context = GEDatabaseWorker.shared.managedContext else { return [] }
        let fetchGenreRequest = Genre.fetchRequest()
        do {
            let genres = try context.fetch(fetchGenreRequest)
            return genres
        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    private func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == 133021 {
                //print("## Duplicate detected")
            }
            //print("Could not save. \(error), \(error.userInfo)")
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
