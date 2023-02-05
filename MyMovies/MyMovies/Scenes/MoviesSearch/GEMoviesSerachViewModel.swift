//
//  GEMoviesSerachViewModel.swift
//  MyMovies
//
//  Created by Avin on 5/2/23.
//
import Foundation
import Combine
class GEMoviesSerachViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    private var cancellables = Set<AnyCancellable>()
    var currentPage = 0
    var nextPage = 1
    var movieName = "Avatar"
    func fetchData() {
        nextPage = currentPage + 1
        self.fetchMovieRequestController?.fetchRequest.predicate =
        NSPredicate(format: "title == %@", self.movieName)
        
        fetch(.query((movieName, nextPage))).sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .finished:
                self.currentPage = self.nextPage
                DispatchQueue.main.async {
                    do {
                        try self.fetchMovieRequestController?.performFetch()
                        self.delegate?.updateUI()
                    } catch {
                        print(error)
                    }
                }
                    
                
            case .failure(let error):
                print("failure \(error)")
            }
        } receiveValue: { result in
            
        }.store(in: &cancellables)
    }
}

