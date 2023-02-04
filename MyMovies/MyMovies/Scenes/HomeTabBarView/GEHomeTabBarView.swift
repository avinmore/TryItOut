//
//  GEHomeTabBarView.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//
import UIKit

class GEHomeTabBarView: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        
        let nowPlaying = GENowPlayingMoviesViewController()
        let firstTabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        nowPlaying.tabBarItem = firstTabBarItem
        
        let popular = GEPopularMoviesViewController()
        let secondTabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        popular.tabBarItem = secondTabBarItem
        
        let toprated = GETopRatedMoviesViewController()
        let thirdTabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 2)
        toprated.tabBarItem = thirdTabBarItem
        
        let upcoming = GEUpcomingMoviesViewController()
        let fourthTabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        upcoming.tabBarItem = fourthTabBarItem
        viewControllers = [ nowPlaying,
                            popular,
                            toprated,
                            upcoming
        ]        
    }
    
    
}
