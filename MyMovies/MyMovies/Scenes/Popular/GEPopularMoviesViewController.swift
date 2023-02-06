//
//  GEPopularMoviesViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import UIKit
class GEPopularMoviesViewController: GEMoviesBaseViewController {
    lazy var viewModel = GEPopularMoviesViewModel()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = setupCollectionView(self)
        collectionView.dataSource = nil
        setupDataSource()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GEMovieBaseViewModel.currentCategory = MovieCategoryType.popular
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
            cell.loadCellData(movie)
            return cell
        })
    }
}

extension GEPopularMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pupularNumberOfItemInSections(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CGMovieCollectionViewCell", for: indexPath) as? CGMovieCollectionViewCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        
        cell.loadCellData(viewModel.popularMovieForIndexPath(indexPath))
        //let movie = viewModel.popularMovieForIndexPath(indexPath)
        //debugPrint("### \(movie?.is_popular)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.viewModel.movieData[indexPath.row]
        navigateToMovieDetails(movie.id)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let totalItemCount = self.viewModel.movieData.count
        if indexPath.row == totalItemCount - 5 {
            viewModel.fetchData()
        }
    }
    
}

extension GEPopularMoviesViewController: GERefreshEventProtocol {
    func updateUI() {
//          collectionView.reloadData()
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
