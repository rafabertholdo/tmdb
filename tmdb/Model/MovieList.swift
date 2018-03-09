//
//  MovieList.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 09/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation
typealias NextPageCompletion = (() throws -> [Movie]) -> Void

class MovieList {    
    private var page = 0
    
    func refresh(requestFunction: MovieListRequestFunction, nextPageCompletion: @escaping NextPageCompletion) {
        page = 0
        loadNextPage(requestFunction: requestFunction, nextPageCompletion: nextPageCompletion)
    }
    
    func loadNextPage(requestFunction: MovieListRequestFunction, nextPageCompletion: @escaping NextPageCompletion) {
        page += 1
        requestFunction( ["page": page]) { (completion) in
            do {
                guard let result = try completion() else {
                    throw ApiError.emptyResponse
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    nextPageCompletion { return result }
                }
            } catch {
                nextPageCompletion { throw error }
            }
        }
    }
}
