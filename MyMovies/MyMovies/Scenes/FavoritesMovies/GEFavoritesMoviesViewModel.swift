//
//  GEFavoritesMoviesViewModel.swift
//  MyMovies
//
//  Created by Avin on 6/2/23.
//

import Foundation
class GEFavoritesMoviesViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    var favoriteMovies: [GEMovie] = []
    func fetchData() {
        favoriteMovies = GEDatabaseManager.shared.fetchAllfavoritesMovies()
        delegate?.updateUI()
    }
}
