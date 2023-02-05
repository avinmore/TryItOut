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

extension Genre {
    func toGenre() -> Genres {
        return Genres(id: Int(self.id), name: self.name ?? "")
    }
}
