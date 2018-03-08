//
//  TMDBProvider.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation
typealias MovieListCallback = (@escaping () throws -> [Movie]?) -> Void

class TMDBProvider {
    
    private struct Constants {
        static let apiVersion = "3"
        static var baseUrl: String {
            return "https://api.themoviedb.org/" + apiVersion
        }
        static var upcomingEndpoint: String {
            return baseUrl + "/movie/upcoming"
        }
        static var popularEndpoint: String {
            return baseUrl + "/movie/popular"
        }
        static var movieEndpoint: String {
            return baseUrl + "/movie/"
        }
        static let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
        static let bannerBaseUrl = "https://image.tmdb.org/t/p/original"
        static let apiSecret = ["api_key": "1f54bd990f1cdfb230adb312546d765d"]
        static let profileBaseUrl = "https://image.tmdb.org/t/p/w185"
        static let results = "results"
    }
    
    public static let instance = TMDBProvider()
    private var backendClient: NetworkProviderProtocol
    
    public init(_ backendClient: NetworkProviderProtocol = AlamofireNetworkProvider.instance) {
        self.backendClient = backendClient
    }
    
    /// Searches the most popular movies at TMDB
    ///
    /// - Parameters:
    ///   - parameters: request parameters
    ///   - completion: Closure executed at the end of the request
    func popularMovies(with parameters: [String: Any], completion: @escaping MovieListCallback ) {
        request(withUrl: Constants.popularEndpoint, andParameters: parameters, completion: completion)
    }
    
    /// Searches the most popular movies at TMDB
    ///
    /// - Parameters:
    ///   - parameters: request parameters
    ///   - completion: Closure executed at the end of the request
    func upcomingMovies(with parameters: [String: Any], completion: @escaping MovieListCallback ) {
        request(withUrl: Constants.upcomingEndpoint, andParameters: parameters, completion: completion)
    }
    
    /// Makes a request to backend at particular URL
    ///
    /// - Parameters:
    ///   - parameters: url path
    ///   - parameters: request parameters
    ///   - completion: Closure executed at the end of the request
    func request(withUrl url: String, andParameters parameters: [String: Any], completion: @escaping MovieListCallback) {
        backendClient.request(url, method: .get, parameters: parameters.merged(with: Constants.apiSecret)) { (callback) in
            do {
                guard let result = try callback() else {
                    throw ApiError.emptyResponse
                }
                let json = try result.data.toDictionary()
                guard let resultsDictionary = json[Constants.results] as? [[String: AnyObject]] else {
                    completion { throw BusinessError.couldNotParseProperty(Constants.results) }
                    return
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: resultsDictionary, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let movies: [Movie] = try decoder.decode([Movie].self, from: jsonData)
                let urlResolvedMovies = movies.map({ (movie) -> Movie in
                    return Movie(title: movie.title, coverUrl: movie.coverUrl != nil ? Constants.posterBaseUrl + movie.coverUrl! : nil)
                })
                completion { return urlResolvedMovies }
            } catch {
                completion { throw error }
            }
        }
    }
}
