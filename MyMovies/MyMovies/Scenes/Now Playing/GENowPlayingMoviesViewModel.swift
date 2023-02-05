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

protocol GEFetchMovieData {
    func fetchData()
}

protocol GENowPlayingMoviesViewModelProtocol {
//    func insertObjectAtIndex(_ index: IndexPath)
    func updateUI()
}

class GENowPlayingMoviesViewModel: NSObject, GEFetchMovieData {
    private var pageIndex = 1
    var currentPage = 0
    var nextPage = 1
    var totalPages = 0
    private var cancellables = Set<AnyCancellable>()
    var blockOfOperation = [BlockOperation]()
    var updateIndexes = [IndexPath]()
    var delegate: GENowPlayingMoviesViewModelProtocol?
    var movies: [GEMovie] = []
    func fetchData() {
        nextPage = currentPage + 1
        debugPrint("### fetching page \(nextPage)")
        GENetworkDataManager.shared.fetchDataRequest(.nowPlaying(nextPage),
            responseType: Movies.self).sink { [weak self] completion in
            switch completion {
            case .finished:
                guard let self = self else { return }
                self.currentPage = self.nextPage
                debugPrint("### fetched page \(self.nextPage)")
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
    
    func numberOfItemInSections(_ section: Int) -> Int {
        return fetchMovieRequestController?.sections?[section].numberOfObjects ?? 0
    }
    
    func movieForIndexPath(_ indexPath: IndexPath) -> GEMovie? {
        let movie = fetchMovieRequestController?.object(at: indexPath)
        return movie?.toCGMovie()
    }
        
    //Database
    func setupDataSync() {
        do {
            try fetchMovieRequestController?.performFetch()
        } catch {
            print("error \(error)")
        }
    }
    
    lazy var fetchMovieRequestController: NSFetchedResultsController<Movie>? = {
        guard let context = GEDatabaseWorker.shared.managedContext else { return nil }
        let fetchRequest = Movie.fetchRequest()
        let sortDescripters = [NSSortDescriptor(key: "dateAdded", ascending: true)]
        fetchRequest.sortDescriptors = sortDescripters
        let fetchResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResult.delegate = self
        return fetchResult
    }()
    
    
}

extension GENowPlayingMoviesViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            if let index = newIndexPath {
                updateIndexes.append(index)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateUI()
    }
}
