//
//  MovieListViewController.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, ViewCustomizable {
    typealias MainView = MovieListView
    
    let queue = TMDBOperationQueue()
    var movies: [Movie]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.setLoadingScreen(view: mainView, navigationController: navigationController)
        queue.popularMovies { [weak self] (completion) in
            do {
                guard let weakSelf = self else { return }
                guard let result = try completion() else {
                    throw ApiError.emptyResponse
                }
                
                let moviesViewModel = result.map { (movie) -> MovieViewModel? in
                    return MovieViewModel(movie)
                    }.filter({ (viewModel) -> Bool in
                        return viewModel != nil
                    })                
                weakSelf.mainView.movies = moviesViewModel
                weakSelf.mainView.removeLoadingScreen()
            } catch {
                
            }
        }
    }
}
