//
//  GEMovieDetailModel.swift
//  MyMovies
//
//  Created by Avin on 6/2/23.
//

import Foundation
// MARK: - Welcome
struct GEMovieDetailModel: Codable {
    let adult: Bool? = false
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [Genres]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Float?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool? = false
    let voteAverage: Float?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

extension MovieDetail {
    func toGEMovieDetailModel() -> GEMovieDetailModel {
        return GEMovieDetailModel(
            backdropPath: self.backdrop_path ,
            belongsToCollection: nil ,
            budget: Int(self.budget) ,
            genres: try? JSONDecoder().decode([Genres].self, from: self.genres ?? Data()),
            homepage: self.homepage ,
            id: Int(self.id),
            imdbID: self.imdb_id ,
            originalLanguage: self.original_language ,
            originalTitle: self.original_title ,
            overview: self.overview ,
            popularity: self.popularity ,
            posterPath: self.poster_path ,
            productionCompanies: nil ,
            productionCountries: nil ,
            releaseDate: self.release_date ,
            revenue: Int(self.revenue),
            runtime: Int(self.runtime),
            spokenLanguages: try? JSONDecoder().decode([SpokenLanguage].self, from: self.spoken_languages ?? Data()),
            status: self.status ,
            tagline: self.tagline ,
            title: self.title ,
            voteAverage: self.vote_average,
            voteCount: Int(self.vote_average))
    }
}
