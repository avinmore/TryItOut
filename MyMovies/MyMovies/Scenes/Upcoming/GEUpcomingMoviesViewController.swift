//
//  GEUpcomingMoviesViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import UIKit
class GEUpcomingMoviesViewController: GEMoviesBaseViewController {
    lazy var viewModel = GEUpcomingMoviesViewModel()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = setupCollectionView(self)
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GEMovieBaseViewModel.currentCategory = MovieCategoryType.upcoming
        viewModel.setupDataSync()
        viewModel.fetchData()
    }
}
extension GEUpcomingMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSections(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CGMovieCollectionViewCell", for: indexPath) as? CGMovieCollectionViewCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        
        cell.loadCellData(viewModel.movieForIndexPath(indexPath))
        let movie = viewModel.movieForIndexPath(indexPath)
        debugPrint("### \(movie?.is_upcoming)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movieForIndexPath(indexPath)
        navigateToMovieDetails(movie?.id)
    }
}

extension GEUpcomingMoviesViewController: GERefreshEventProtocol {
    func updateUI() {
    //        collectionView.reloadData()
    //        return
        collectionView.performBatchUpdates { [weak self] in
            guard let self = self else { return }
            self.collectionView.insertItems(at: self.viewModel.updateIndexes)
        } completion: { completed in
            self.viewModel.updateIndexes.removeAll()
            debugPrint("")
        }
    }
}

