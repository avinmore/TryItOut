//
//  GEUpcomingMoviesViewModel.swift
//  MyMovies
//
//  Created by Avin on 5/2/23.
//
import Foundation
import Combine
import UIKit
class GEUpcomingMoviesViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    private var cancellables = Set<AnyCancellable>()
    var currentPage = 0
    var nextPage = 1
    var movieData: [GEMovie] = []
    var isRefreshing = false
    var dataSource: UICollectionViewDiffableDataSource<Section, GEMovie>!
    
    func fetchData() {
        nextPage = currentPage + 1
        fetch(.upcoming(nextPage), Movies.self).sink { completion in
            switch completion {
            case .finished:
                self.currentPage = self.nextPage
            case .failure(let error):
                print("failure \(error)")
            }
            DispatchQueue.main.async { [weak self] in
                self?.updateDataSource()
            }
        } receiveValue: { result in
            
        }.store(in: &cancellables)
    }
    
    func updateDataSource() {
        GEDatabaseManager.shared.fetchMoviesByCategoriesWith(MovieCategoryType.upcoming.rawValue) { movies in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return}
                self.movieData = movies
                var snapshot = NSDiffableDataSourceSnapshot<Section, GEMovie>()
                snapshot.appendSections([.first])
                snapshot.appendItems(self.movieData)
                self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
                self.isRefreshing = false
            }
        }
    }
}
