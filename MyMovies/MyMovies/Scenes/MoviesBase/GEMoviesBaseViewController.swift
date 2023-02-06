//
//  GEMoviesBaseViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import UIKit
class GEMoviesBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupCollectionView(_ controller: UIViewController & UICollectionViewDelegate & UICollectionViewDataSource) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CGMovieCollectionViewCell.self, forCellWithReuseIdentifier: "CGMovieCollectionViewCell")
        collectionView.frame = controller.view.frame
        collectionView.delegate = controller
//        collectionView.dataSource = controller
        controller.view.addSubview(collectionView)
        // Add constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: controller.view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        ])
        
        return collectionView
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        //--------- Set 1 ---------//
        //2 second row half cell
        let group1Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                                                                    heightDimension: .fractionalHeight(1)))
        group1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        
        //3 second top right cell
        let nestedGroup1Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .fractionalHeight(1/2)))
        nestedGroup1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        //4 second bottom right 2 cells
        let nestedGroup2Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                                                                          heightDimension: .fractionalHeight(1)))
        
        nestedGroup2Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let group1 = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1/3)),
                                                        subitems: [group1Item1])
        
        //--------- Set 2 ---------//
        //5 third row all cells
        let group2Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                                    heightDimension: .fractionalHeight(1)))
        group2Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                           heightDimension: .fractionalHeight(1/3)),
                                                        subitems: [group2Item1])
        
        
        //--------- Set Container ---------//
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                                 heightDimension: .absolute(600)),
                                                              subitems: [group1, group2])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func navigateToMovieDetails(_ movieId: Int?) {
        guard let id = movieId else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDetailsViewController = storyboard.instantiateViewController(withIdentifier: "GEMovieDetailsViewController") as? GEMovieDetailsViewController else { return }
        movieDetailsViewController.viewModel.movieId = id
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }

}
