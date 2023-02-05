//
//  GEMovieModel.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//
import Foundation
struct Movies: Codable {
    let dates: Dates?
    let page: Int
    let results: [CGMovie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    let maximum, minimum: String
}

struct CGMovie: Codable, Hashable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
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
//Move to other file
extension Movie {
    func toCGMovie() -> CGMovie {
        return CGMovie(adult: self.adult,
                       backdropPath: self.backdrop_path ?? "",
                       genreIDS: self.genre_ids?.dataToInt ?? [],
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
                       voteCount: Int(self.vote_count))
    }
}
