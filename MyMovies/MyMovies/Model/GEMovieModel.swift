//
//  GEMovieModel.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//
import Foundation
struct Movies: Codable, Hashable {
    let dates: Dates?
    let page: Int
    let results: [GEMovie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable, Hashable {
    let maximum, minimum: String
}

struct GEMovie: Codable, Hashable {
    var adult: Bool = false
    var backdropPath: String?
    var genreIDS: [Int]?
    var genreList: String?
    let id: Int
    var originalLanguage: String?
    var originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var is_now_playing: Bool = false
    var is_popular: Bool = false
    var is_top_rated: Bool = false
    var is_upcoming: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case genreList = "genre_list"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension GEMovie: Equatable {
    static func == (lhs: GEMovie, rhs: GEMovie) -> Bool {
        return lhs.id == rhs.id
    }
}

//Move to other file
extension Movie {
    func toCGMovie() -> GEMovie {
        return GEMovie(adult: self.adult,
                       backdropPath: self.backdrop_path ?? "",
                       genreIDS: self.genre_ids?.dataToInt ?? [],
                       genreList: self.genre_list,
                       id: Int(self.id),
                       originalLanguage: self.original_language ?? "",
                       originalTitle: self.original_title ?? "",
                       overview: self.overview ?? "",
                       popularity: self.popularity,
                       posterPath: self.poster_path ?? "",
                       releaseDate: self.release_date ?? "",
                       title: self.title ?? "",
                       video: self.video,
                       voteAverage: self.vote_average,
                       voteCount: Int(self.vote_count),
                       is_now_playing: self.is_now_playing,
                       is_popular: self.is_popular,
                       is_top_rated: self.is_top_rated,
                       is_upcoming: self.is_upcoming)
    }
}

enum Section {
    case first
}
