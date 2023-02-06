//
//  GEFavoritesMoviesViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import UIKit
class GEFavoritesMoviesViewController: GEMoviesBaseViewController {
    lazy var viewModel = GEFavoritesMoviesViewModel()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = setupCollectionView(self)
        collectionView.dataSource = self
        viewModel.delegate = self
        //viewModel.setupDataSync()
        viewModel.fetchData()
    }
}
extension GEFavoritesMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CGMovieCollectionViewCell", for: indexPath) as? CGMovieCollectionViewCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        cell.loadCellData(viewModel.favoriteMovies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.favoriteMovies[indexPath.row]
        navigateToMovieDetails(movie.id)
    }
}

extension GEFavoritesMoviesViewController: GERefreshEventProtocol {
    func updateUI() {
        collectionView.performBatchUpdates { [weak self] in
            guard let self = self else { return }
            self.collectionView.insertItems(at: self.viewModel.updateIndexes)
        } completion: { completed in
            self.viewModel.updateIndexes.removeAll()
            debugPrint("")
        }
    }
}
