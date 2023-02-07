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
@propertyWrapper
class Atomic <T> {
    private let lock = NSLock.init()
    private var object: T?
    var wrappedValue: T? {
        get {
            lock.lock()
            let ret = object
            lock.unlock()
            return ret
        }
        set {
            lock.lock()
            object = newValue
            lock.unlock()
        }
    }
}

class GEDatabaseWorker {
    static let shared = GEDatabaseWorker()
    private init() {}
//    var managedContext: NSManagedObjectContext?
    let databaseQueue = DispatchQueue(label: "com.database.queue", qos: .userInteractive)
    @Atomic var managedContext: NSManagedObjectContext?
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private var genres: [Genres] = []
    
    func saveDatabase() {
        do {
            try self.privateMOC.save()
            GEDatabaseWorker.shared.managedContext?.performAndWait {
                do {
                    try GEDatabaseWorker.shared.managedContext?.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    func saveMovies(_ movies: Movies, category: String, completion:  @escaping () -> Void) {
        
        databaseQueue.async {
            
            
            
            if GEDatabaseWorker.shared.privateMOC.parent == nil {
                GEDatabaseWorker.shared.privateMOC.parent = GEDatabaseWorker.shared.managedContext
            }
            
            if self.genres.isEmpty {
                self.genres = GEDatabaseWorker.shared.fetchGenre().map { $0.toGenre() }
            }
            //privateMOC.perform {
            guard let context = GEDatabaseWorker.shared.managedContext else { return }
            for movie in movies.results {
                let fetchMoviesRequest = Movie.fetchRequest()
                fetchMoviesRequest.predicate = NSPredicate(format: "id == \(movie.id)")
                do {
                    let existing = try context.fetch(fetchMoviesRequest)
                    if let existingObject = existing.first {
                        existingObject.is_popular = existingObject.is_popular ? existingObject.is_popular : category == MovieCategoryType.popular.rawValue
                        existingObject.is_upcoming = existingObject.is_upcoming ? existingObject.is_upcoming : category == MovieCategoryType.upcoming.rawValue
                        existingObject.is_top_rated = existingObject.is_top_rated ? existingObject.is_top_rated : category == MovieCategoryType.top_rated.rawValue
                        existingObject.is_now_playing = existingObject.is_now_playing ? existingObject.is_now_playing : category == MovieCategoryType.now_playing.rawValue
                        existingObject.dateAdded = Date()
                        self.saveData(context)
                        continue
                    }
                } catch {
                    debugPrint("!!! FIX ME !!! \(error)")
                }
                
                let manageObject = Movie(context: context)
                manageObject.genre_ids = movie.genreIDS?.data
                manageObject.id = Int64(movie.id)
                manageObject.original_language = movie.originalLanguage
                manageObject.adult = movie.adult
                manageObject.original_title = movie.originalTitle
                manageObject.overview = movie.overview
                manageObject.popularity = Date().timeIntervalSince1970 // movie.popularity ?? 0
                manageObject.poster_path = movie.posterPath
                manageObject.release_date = movie.releaseDate
                manageObject.title = movie.title
                manageObject.video = movie.video ?? false
                manageObject.vote_average = movie.voteAverage ?? 0
                manageObject.vote_count = Int64(movie.voteCount ?? 0)
                manageObject.dateAdded = Date()
                manageObject.genre_list = movie.genreIDS?.map { self.fetchGenreFor($0) }.joined(separator: " * ")
                manageObject.is_popular = category == MovieCategoryType.popular.rawValue
                manageObject.is_upcoming = category == MovieCategoryType.upcoming.rawValue
                manageObject.is_top_rated = category == MovieCategoryType.top_rated.rawValue
                manageObject.is_now_playing = category == MovieCategoryType.now_playing.rawValue
                
                let moviecategory = MovieCategory(context: context)
                moviecategory.id = Int64(movie.id)
                moviecategory.type = category
                self.saveData(context)
            }//for
            self.saveData(context)
            completion()
            //}
        }
    }
    
    func fetchGenreFor(_ id: Int) -> String {
        return genres.first(where: { $0.id == id })?.name ?? ""
    }
    
    func saveMovieDetails(_ movieDetail: GEMovieDetailModel, completion:  @escaping () -> Void) {
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
            } catch { }
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
        completion()
    }
    
    func deleteAllGenre(completion:  @escaping () -> Void) {
        databaseQueue.async {
            guard let context = GEDatabaseWorker.shared.managedContext else { return }
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Genre.fetchRequest())
            do {
                try context.execute(batchDeleteRequest)
            } catch { }
            self.saveData(context)
            completion()
        }
    }
    
    func saveGenre(_ genres: GEGenreModel, completion:  @escaping () -> Void) {
        databaseQueue.async {
            self.deleteAllGenre {
                guard let context = GEDatabaseWorker.shared.managedContext else { return }
                for genre in genres.genres {
                    let manageObject = Genre(context: context)
                    manageObject.id = Int64(genre.id)
                    manageObject.name = genre.name
                }
                self.saveData(context)
                completion()
            }
        }
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
        } catch  {}
        saveData(context)
        return status
    }
    
    func fetchAllfavoritesMovies(completion: @escaping ([Movie]) -> Void) {
        let fetchMoviesRequest = FavoriteMovies.fetchRequest()
        do {
            let allfavoriteMovieIds = try GEDatabaseWorker.shared.managedContext?.fetch(fetchMoviesRequest) ?? []
            fetchfavoriteMoviesWith(allfavoriteMovieIds.map({ Int($0.id) })) { movies in
                completion(movies)
            }
        } catch  {
            return completion([])
        }
        
    }
    
    func fetchfavoriteMoviesWith(_ ids: [Int], completion: @escaping ([Movie]) -> Void) {
        databaseQueue.async {
            let fetchMoviesRequest = Movie.fetchRequest()
            let predicate = NSPredicate(format: "id IN %@", ids)
            let sort = NSSortDescriptor(key: "popularity", ascending: true)
            fetchMoviesRequest.sortDescriptors = [sort]
            fetchMoviesRequest.predicate = predicate
            do {
                let movies = try GEDatabaseWorker.shared.managedContext?.fetch(fetchMoviesRequest) ?? []
                completion(movies)
                return
            } catch {
                return completion([])
            }
        }
        
    }
    
    func fetchMoviesByCategoriesWith(category: String, completion: @escaping ([Movie]) -> Void) {
        databaseQueue.async {
            let fetchMoviesRequest = MovieCategory.fetchRequest()
            let predicate = NSPredicate(format: "type = %@", category)
            fetchMoviesRequest.predicate = predicate
            do {
                if let movies = try GEDatabaseWorker.shared.managedContext?.fetch(fetchMoviesRequest) {
                    let ids = Array(Set(Set( movies.map({ Int($0.id) } ) )))
                    self.fetchfavoriteMoviesWith(ids) { movies in
                        completion(movies)
                        return
                    }
                } else {
                    return completion([])
                }
            } catch {
                return completion([])
            }
        }
    }

    func fetchMoviesQuery(_ query: String, completion: @escaping ([Movie]) -> Void) {
        databaseQueue.async {
            guard let context = GEDatabaseWorker.shared.managedContext else { return completion([]) }
            let fetchMoviesRequest = Movie.fetchRequest()
            let predicate = NSPredicate(format: "SELF.title BEGINSWITH[c] %@", query)
            fetchMoviesRequest.predicate = predicate
            do {
                let movies = try context.fetch(fetchMoviesRequest)
                completion(movies)
            } catch {
                return completion([])
            }
        }
    }
        
    func fetchGenre() -> [Genre] {
        guard let context = GEDatabaseWorker.shared.managedContext else { return [] }
        let fetchGenreRequest = Genre.fetchRequest()
        do {
            let genres = try context.fetch(fetchGenreRequest)
            return genres
        } catch {
            return []
        }
    }
    
    private func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == 133021 {
                print("## Duplicate detected")
            }
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
