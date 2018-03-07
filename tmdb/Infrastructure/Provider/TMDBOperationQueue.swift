//
//  TMDBOperationQueue.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

class TMDBOperationQueue: BaseOperationQueue {

    func popularMovies(_ completion: @escaping MovieListCallback) {
        addOperation {
            TMDBProvider.instance.popularMovies { (callback) in
                OperationQueue.main.addOperation {
                    completion(callback)
                }
            }
        }
    }
}
