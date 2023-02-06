//
//  GEMoviesSerachViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import UIKit
class GEMoviesSerachViewController: GEMoviesBaseViewController {
    lazy var viewModel = GEMoviesSerachViewModel()
    var collectionView: UICollectionView!
    lazy var searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = setupCollectionView(self)
        navigationItem.titleView = searchController.searchBar
        //definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchResultsUpdater = self

        viewModel.delegate = self
        viewModel.setupDataSync()
        viewModel.fetchData()
    }
}
extension GEMoviesSerachViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var searchString = searchController.searchBar.text
        searchString = searchString?.trimmingCharacters(in: .whitespaces)
        let filteredString = searchString?.replacingOccurrences(of: "[\\s.]{2,}", with: "", options: .regularExpression)
        if filteredString != viewModel.movieName {
            viewModel.movieName = filteredString ?? ""
            //print("### \(viewModel.movieName)")
        }        
    }
}
extension GEMoviesSerachViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSections(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CGMovieCollectionViewCell", for: indexPath) as? CGMovieCollectionViewCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        cell.loadCellData(viewModel.movieForIndexPath(indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movieForIndexPath(indexPath)
        navigateToMovieDetails(movie?.id)
    }
}

extension GEMoviesSerachViewController: GERefreshEventProtocol {
    func updateUI() {
        collectionView.reloadData()        
    }
}

