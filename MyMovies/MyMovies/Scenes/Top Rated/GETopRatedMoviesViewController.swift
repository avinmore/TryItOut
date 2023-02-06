//
//  GETopRatedMoviesViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import UIKit
class GETopRatedMoviesViewController: GEMoviesBaseViewController {
    lazy var viewModel = GETopRatedMoviesViewModel()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = setupCollectionView(self)
        collectionView.dataSource = nil
        viewModel.delegate = self
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GEMovieBaseViewModel.currentCategory = MovieCategoryType.top_rated
        viewModel.setupDataSync()
        viewModel.fetchData()
    }
    
    func setupDataSource() {
        viewModel.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CGMovieCollectionViewCell", for: indexPath) as? CGMovieCollectionViewCell else {
                assertionFailure()
                return UICollectionViewCell()
            }
            let movie = self.viewModel.movieData[indexPath.row]
            debugPrint("####\(movie.is_now_playing ?? false )")
            cell.loadCellData(movie)
            return cell
        })
    }
    
}
extension GETopRatedMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        debugPrint("### \(movie?.is_top_rated)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movieForIndexPath(indexPath)
        navigateToMovieDetails(movie?.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let totalItemCount = self.viewModel.movieData.count
        if indexPath.row == totalItemCount - 5 {
            viewModel.fetchData()
        }
    }
    
    
}

extension GETopRatedMoviesViewController: GERefreshEventProtocol {
    func updateUI() {
//        collectionView.reloadData()
//        return
//        collectionView.performBatchUpdates { [weak self] in
//            guard let self = self else { return }
//            self.collectionView.insertItems(at: self.viewModel.updateIndexes)
//        } completion: { completed in
//            self.viewModel.updateIndexes.removeAll()
//            debugPrint("")
//        }
    }
}

