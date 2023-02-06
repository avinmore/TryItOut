//
//  GENowPlayingMoviesViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import UIKit
import Kingfisher

class GENowPlayingMoviesViewController: GEMoviesBaseViewController {
    lazy var viewModel = GENowPlayingMoviesViewModel()
    var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = setupCollectionView(self)
        collectionView.dataSource = nil
        setupDataSource()
        viewModel.delegate = self
        viewModel.fetchGenreData()
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
//            debugPrint("####\(movie.is_now_playing ?? false )")
            cell.loadCellData(movie)
            return cell
        })
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GEMovieBaseViewModel.currentCategory = MovieCategoryType.now_playing
        viewModel.setupDataSync()
        viewModel.fetchData()
    }
}

extension GENowPlayingMoviesViewController: GERefreshEventProtocol {
    func updateUI() {
        //viewModel.updateDataSource()
//        collectionView.performBatchUpdates { [weak self] in
//            guard let self = self else { return }
//            self.collectionView.insertItems(at: self.viewModel.updateIndexes)
//        } completion: { completed in
//            self.viewModel.updateIndexes.removeAll()
//            debugPrint("")
//        }
    }
}

extension GENowPlayingMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSections(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CGMovieCollectionViewCell", for: indexPath) as? CGMovieCollectionViewCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        let movie = viewModel.movieForIndexPath(indexPath)
        cell.loadCellData(movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let totalItemCount = self.viewModel.movieData.count
        if indexPath.row == totalItemCount - 5 {
            viewModel.fetchData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movieForIndexPath(indexPath)
        navigateToMovieDetails(movie?.id)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0.4...1),
                       green: .random(in: 0.4...1),
                       blue: .random(in: 0.4...1),
                       alpha: 1)
    }
}
