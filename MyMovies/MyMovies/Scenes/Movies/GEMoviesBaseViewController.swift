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
    
    func setupCollectionView(_ controller: UIViewController & UICollectionViewDelegate & UICollectionViewDataSource) {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.frame = controller.view.frame
        collectionView.delegate = controller
        collectionView.dataSource = controller
        controller.view.addSubview(collectionView)
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        //1 first big cell
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1/3)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
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
        
        let nestedGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                                 heightDimension: .fractionalHeight(1/2)),
                                                              subitems: [nestedGroup2Item1])
        
        let nestedGroup1 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                                                                               heightDimension: .fractionalHeight(1)),
                                                            subitems: [nestedGroup1Item1, nestedGroup2])
        
        let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                           heightDimension: .fractionalHeight(1/3)),
                                                        subitems: [group1Item1, nestedGroup1])
        
        
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
                                                              subitems: [item, group1, group2])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
