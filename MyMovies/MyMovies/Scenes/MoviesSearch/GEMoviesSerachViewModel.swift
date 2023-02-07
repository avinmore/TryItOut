//
//  GEMoviesSerachViewModel.swift
//  MyMovies
//
//  Created by Avin on 5/2/23.
//
import Foundation
import Combine
import UIKit
class GEMoviesSerachViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    private var cancellables = Set<AnyCancellable>()
    var currentPage = 0
    var nextPage = 1
    var movieData: [GEMovie] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, GEMovie>!
    
    var movieName = "" {
        didSet {
            currentPage = 0
            nextPage = 1
            fetchData()
        }
    }
    func fetchData() {
        guard !movieName.isEmpty else { return }
        nextPage = currentPage + 1
        fetch(.query((movieName, nextPage)), Movies.self).sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .finished:
                self.currentPage = self.nextPage
            case .failure(let error):
                print("failure \(error)")
            }
            DispatchQueue.main.async {
                self.updateDataSource()
            }
        } receiveValue: { result in
            
        }.store(in: &cancellables)
    }
    
    func updateDataSource() {
        GEDatabaseManager.shared.fetchAllMoviesWithQuery(self.movieName) { [weak self] movies in
            DispatchQueue.main.async {
                self?.movieData = movies
                var snapshot = NSDiffableDataSourceSnapshot<Section, GEMovie>()
                snapshot.appendSections([.first])
                snapshot.appendItems(self?.movieData ?? [])
                self?.dataSource?.apply(snapshot)
            }
        }
    }
}

