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
        GEDatabaseManager.shared.fetchAllfavoritesMovies(completion: { [weak self] movies in
            DispatchQueue.main.async {
                self?.favoriteMovies = movies
                self?.delegate?.updateUI()
            }
        })
    }
}
