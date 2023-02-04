//
//  GETopRatedMoviesViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import UIKit
class GETopRatedMoviesViewController: GEMoviesBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(self)
    }
}
extension GETopRatedMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        cell.backgroundColor = .random
        return cell
    }
}
