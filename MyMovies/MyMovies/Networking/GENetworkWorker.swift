//
//  GENetworkWorker.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import Combine
enum GEAPIError: Error {
    case invalidURL
    case invalidResponse
}

protocol GEEnvironmentProtocol {
    var baseURL: String { get }
    var imageBaseURL: String { get }
    var apiKeyParam: String { get }
}

enum APIEnvironment: GEEnvironmentProtocol {
    case development
    var baseURL: String {
        switch self {
        case .development:
            return "https://api.themoviedb.org/3/"
        }
    }
    var imageBaseURL: String {
        return "https://image.tmdb.org/t/p/original/"
    }
    var apiKeyParam: String {
        return "api_key=0e7274f05c36db12cbe71d9ab0393d47"
    }
}
class GENetworkWorker {
    static let shared = GENetworkWorker()
    private init() {}
    let environment = APIEnvironment.development
    let networkQueue = DispatchQueue(label: "com.network.queue", qos: .utility)
    
    func makeRequest(query: String) -> Future<Data?, Error> {
        guard let url = URL(string: environment.baseURL + query + environment.apiKeyParam) else {
            return Future { promis in
                promis(.failure(GEAPIError.invalidURL))
            }
        }
        //debugPrint("### \(url)")
        return Future { promis in
            self.networkQueue.async {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return promis(.failure(GEAPIError.invalidResponse))
                    }
                    promis(.success(data))
                }.resume()
            }
        }
    }
}
