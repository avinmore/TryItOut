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
        setupDataSource()
        viewModel.setupDataSync()
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GEMovieBaseViewModel.currentCategory = MovieCategoryType.upcoming
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
extension GEUpcomingMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.viewModel.movieData[indexPath.row]
        navigateToMovieDetails(movie.id)
    }
    
    func isCollectionViewAtEnd(collectionView: UICollectionView) -> Bool {
        let offset = collectionView.contentOffset.y
        let bounds = collectionView.bounds.size.height
        let contentSize = collectionView.contentSize.height
        let result = offset + bounds >= contentSize
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let totalItemCount = self.viewModel.movieData.count
        if indexPath.row == totalItemCount - 5 {
            viewModel.fetchData()
        }
    }
}

extension GEUpcomingMoviesViewController: GERefreshEventProtocol {
    func updateUI() {
    }
}

