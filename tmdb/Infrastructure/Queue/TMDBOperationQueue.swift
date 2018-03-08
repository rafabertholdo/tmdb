//
//  TMDBOperationQueue.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

class TMDBOperationQueue: BaseOperationQueue {
    
    /// Removes the execution from the main queue and call
    /// the TMDB provider to get the list of the popular movies
    ///
    /// - Parameter completion: Closure executed on the main queue at the end of the request
    func popularMovies(with parameters: [String: Any], completion: @escaping MovieListCallback) {
        addOperation {
            TMDBProvider.instance.popularMovies(with: parameters, completion: { (callback) in
                OperationQueue.main.addOperation {
                    completion(callback)
                }
            })
        }
    }
}
