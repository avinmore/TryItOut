//
//  GENowPlayingMoviesViewModel.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import Combine
protocol GEFetchMovieData {
    func fetchData()
}
class GENowPlayingMoviesViewModel: GEFetchMovieData {
    private var pageIndex = 1
    private var cancellables = Set<AnyCancellable>()
    func fetchData() {
        GENetworkDataManager.shared.fetchDataRequest(.nowPlaying(pageIndex), responseType: Movies.self).sink { completion in
            switch completion {
            case .finished:
                print("Finish")
            case .failure(let error):
                print("failure \(error)")
            }
        } receiveValue: { result in
//            print(result)
        }.store(in: &cancellables)

    }
    func fetchGenreData() {
        GENetworkDataManager.shared.fetchDataRequest(.genre, responseType: GEGenreModel.self).sink { completion in
            switch completion {
            case .finished:
                print("Finish")
            case .failure(let error):
                print("failure \(error)")
            }
        } receiveValue: { result in
//            print(result)
        }.store(in: &cancellables)
    }
}
