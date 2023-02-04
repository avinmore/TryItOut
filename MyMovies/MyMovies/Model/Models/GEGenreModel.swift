//
//  GEGenreModel.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation

struct GEGenreModel: Codable {
    let genres: [Genres]
}
// MARK: - Genre
struct Genres: Codable {
    let id: Int
    let name: String
}
