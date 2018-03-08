//
//  MovieListViewController.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

typealias NextPageCompletion = () -> Void

class MovieListViewController: UIViewController, ViewCustomizable {
    typealias MainView = MovieListView
    
    let queue = TMDBOperationQueue()
    var movies: [Movie]?    
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.movieDelegate = self
    }
    
    /// Requests the most popular movies
    ///
    /// - Parameter animated: view will appear animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refresh { }
    }
    
    func loadNextPage(nextPageCompletion: @escaping NextPageCompletion) {
        page+=1
        queue.popularMovies(with: ["page": page]) { [weak self] (completion) in
            do {
                guard let weakSelf = self else { return }
                guard let result = try completion() else {
                    throw ApiError.emptyResponse
                }
                
                let moviesViewModel = try result.map { (movie) -> MovieViewModel! in
                    guard let viewModel = MovieViewModel(movie) else {
                        throw BusinessError.couldCreateViewModel
                    }
                    return viewModel
                }
                weakSelf.mainView.movies += moviesViewModel
                nextPageCompletion()
            } catch {
                
            }
        }
    }
}

extension MovieListViewController: MovieListViewDelegate {
    
    func refresh(completion: @escaping () -> Void) {
        mainView.setLoadingScreen(navigationController: navigationController)
        mainView.movies = []
        page = 0
        loadNextPage { [weak self] () in
            guard let weakSelf = self else { return }
            sleep(3)
            weakSelf.mainView.removeLoadingScreen()
            completion()
        }
    }
    
    func requestNextPage(completion: @escaping () -> Void) {
        loadNextPage {
            completion()
        }
    }
}
