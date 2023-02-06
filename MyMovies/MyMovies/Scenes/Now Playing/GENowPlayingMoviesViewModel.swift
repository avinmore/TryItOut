//
//  GENowPlayingMoviesViewModel.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class GENowPlayingMoviesViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    private var cancellables = Set<AnyCancellable>()
    var currentPage = 0
    var nextPage = 1
    func fetchData() {
        nextPage = currentPage + 1
        fetch(.nowPlaying(nextPage), Movies.self).sink { completion in
            switch completion {
            case .finished:
                self.currentPage = self.nextPage
            case .failure(let error):
                print("failure \(error)")
            }
        } receiveValue: { result in
            
        }.store(in: &cancellables)
    }
}
