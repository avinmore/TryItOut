//
//  GEMovieBaseViewModel.swift
//  MyMovies
//
//  Created by Avin on 5/2/23.
//

import Foundation
import Combine
import CoreData

protocol GEFetchMovieData {
    func fetchData()
}

protocol GERefreshEventProtocol {
    func updateUI()
}

class GEMovieBaseViewModel: NSObject {
    
    private var cancellablesObserver = Set<AnyCancellable>()
    var updateIndexes = [IndexPath]()
    var delegate: GERefreshEventProtocol?
    
    func fetch(_ type: GEAPIRequestType<Int, (String, Int)>) -> Future<Bool, Error> {
        return Future { [weak self] promis in
            guard let self = self else { return }
            GENetworkDataManager.shared.fetchDataRequest(type,
                responseType: Movies.self).sink { completion in
                switch completion {
                case .finished:
                    promis(.success(true))
                case .failure(let _):
                    promis(.failure(GEAPIError.invalidResponse))
                }
            } receiveValue: { result in
            }.store(in: &self.cancellablesObserver)
        }
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
        }.store(in: &cancellablesObserver)
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

extension GEMovieBaseViewModel: NSFetchedResultsControllerDelegate {
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
