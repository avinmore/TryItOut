//
//  GEProtocols.swift
//  MyMovies
//
//  Created by Avin Tryambak on 8/2/23.
//

import Foundation

protocol GEFetchMovieData {
    func fetchData()
}

protocol GERefreshEventProtocol {
    func updateUI()
}

enum MovieCategoryType: String {
    case now_playing = "now_playing"
    case popular = "popular"
    case top_rated = "top_rated"
    case upcoming = "upcoming"
    case none
}
