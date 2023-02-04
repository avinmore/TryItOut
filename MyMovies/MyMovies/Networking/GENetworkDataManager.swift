//
//  GENetworkDataManager.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import Combine
enum GEAPIRequestType<I, S> {
    case nowPlaying(I)
    case popular(I)
    case topRated(I)
    case upcoming(I)
    case query(S)
    case genre
}

class GENetworkDataManager {
    static let shared = GENetworkDataManager()
    private init() {}
    private var cancellables = Set<AnyCancellable>()
    
    func fetchDataRequest<T: Codable>(_ requestType: GEAPIRequestType<Int, (String, Int)>, responseType: T.Type) -> Future<Bool, Error> {
        return Future { [weak self] promis in
            guard let self = self else {
                return promis(.failure(GEAPIError.invalidURL))
            }
            let query = self.prepareQuery(requestType)
            GENetworkWorker.shared.makeRequest(query: query).sink { completion in
                switch completion {
                case .finished:
                    print("Finish")
                case .failure(let error):
                    print("failure \(error)")
                    return promis(.failure(error))
                }
            } receiveValue: { data in
                guard let data = data else { return promis(.failure(GEAPIError.invalidResponse)) }
                guard let response = self.responseParser(data, responseType: T.self) else {
                    return promis(.failure(GEAPIError.invalidResponse))
                }
                GEDatabaseManager.shared.saveData(response)
                return promis(.success(true))
            }.store(in: &self.cancellables)
        }
    }
    
    private func prepareQuery(_ requestType: GEAPIRequestType<Int, (String, Int)>) -> String {
        switch requestType {
        case .nowPlaying(let pageIndex):
            return "movie/now_playing?page=\(pageIndex)&"
        case .popular(let pageIndex):
            return "movie/popular?page=\(pageIndex)&"
        case .topRated(let pageIndex):
            return "movie/top_rated?page=\(pageIndex)&"
        case .upcoming(let pageIndex):
            return "movie/upcoming?page=\(pageIndex)&"
        case .query(let searchParams):
            let queryString = searchParams.0
            let pageIndex = searchParams.1
            return "search/movie?query=\(queryString)&page=\(pageIndex)&"
        case .genre:
            return "genre/movie/list?"
        }
    }
    
    private func responseParser<T: Codable>(_ data: Data, responseType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            debugPrint(T.self)
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            return nil
        }
    }
    
}


//https://api.themoviedb.org/3/movie/now_playing?page=1
//https://api.themoviedb.org/3/movie/popular?page=1
//https://api.themoviedb.org/3/movie/top_rated?page=1
//https://api.themoviedb.org/3/movie/upcoming?page=1
//https://api.themoviedb.org/3/search/movie?query={query}&page=1
