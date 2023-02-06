//
//  GEPopularMoviesViewModel.swift
//  MyMovies
//
//  Created by Avin on 5/2/23.
//

import Foundation
import Combine
import UIKit
class GEPopularMoviesViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    private var cancellables = Set<AnyCancellable>()
    var currentPage = 0
    var nextPage = 1
    var movieData: [GEMovie] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, GEMovie>!
    
    func fetchData() {
        nextPage = currentPage + 1
        fetch(.popular(nextPage), Movies.self).sink { completion in
            switch completion {
            case .finished:
                self.currentPage = self.nextPage
                DispatchQueue.main.async {
                    self.updateDataSource()
                }
            case .failure(let error):
                print("failure \(error)")
            }
        } receiveValue: { result in
            
        }.store(in: &cancellables)
    }
    
    func updateDataSource() {
        fetchOwnData()
        var snapshot = NSDiffableDataSourceSnapshot<Section, GEMovie>()
        snapshot.appendSections([.first])
        snapshot.appendItems(movieData)
        dataSource.apply(snapshot)
    }
    
    func fetchOwnData() {
        movieData = GEDatabaseManager.shared.fetchAllMoviesWith("popular")
        //debugPrint(movieData.count)
    }
}
