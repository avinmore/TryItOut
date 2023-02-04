//
//  GENowPlayingMoviesViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import UIKit
class GENowPlayingMoviesViewController: GEMoviesBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(self)
    }
}

extension GENowPlayingMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
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
