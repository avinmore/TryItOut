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
        viewModel.delegate = self
        viewModel.fetchGenreData()
        viewModel.fetchData()
    }
}

extension GENowPlayingMoviesViewController: GENowPlayingMoviesViewModelProtocol {
    func insertObjectAtIndex(_ index: IndexPath) {
        collectionView.insertItems(at: [index])
    }
    func updateUI() {
        collectionView.performBatchUpdates { [weak self] in
            _ = self?.viewModel.blockOfOperation.map { operation in
                operation.start()
            }
        } completion: { completed in
            debugPrint("")
        }
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
        cell.loadCellData(viewModel.movieForIndexPath(indexPath))
        //cell.loadImage(viewModel.movieForIndexPath(indexPath)?.posterPath)
        cell.backgroundColor = .random
        return cell
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
