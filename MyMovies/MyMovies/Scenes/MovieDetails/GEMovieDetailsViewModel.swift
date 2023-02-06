//
//  GEMovieDetailsViewModel.swift
//  MyMovies
//
//  Created by Avin on 6/2/23.
//

import Foundation
import Combine
class GEMovieDetailsViewModel: GEMovieBaseViewModel, GEFetchMovieData {
    private var cancellables = Set<AnyCancellable>()
    var movieId: Int? {
        didSet {
            fetchData()
        }
    }
    
    func fetchData() {
        guard let movieId = movieId else { return }
        fetch(.details(movieId), GEMovieDetailModel.self).sink { completion in
            switch completion {
            case .finished:
                
                DispatchQueue.main.async {
                    self.fetchMovieDetailsRequestController?.fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
                    try? self.fetchMovieDetailsRequestController?.performFetch()
                    self.delegate?.updateUI()
                }
                print("finished")
            case .failure(let error):
                print("failure \(error)")
            }
        } receiveValue: { result in
            
        }.store(in: &cancellables)
    }
}
