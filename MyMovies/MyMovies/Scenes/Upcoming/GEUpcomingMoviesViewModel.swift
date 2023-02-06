//
//  GEUpcomingMoviesViewModel.swift
//  MyMovies
//
//  Created by Avin on 5/2/23.
//
import Foundation
import Combine

class GEUpcomingMoviesViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    private var cancellables = Set<AnyCancellable>()
    var currentPage = 0
    var nextPage = 1
    func fetchData() {
        nextPage = currentPage + 1
        fetch(.upcoming(nextPage), Movies.self).sink { completion in
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
