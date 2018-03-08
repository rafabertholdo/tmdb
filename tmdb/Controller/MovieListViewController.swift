//
//  MovieListViewController.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

typealias NextPageCompletion = () -> Void
typealias MovieListRequestFunction = ([String: Any], @escaping MovieListCallback) -> Void

class MovieListViewController: UIViewController, ViewCustomizable {
    typealias MainView = MovieListView
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let queue = TMDBOperationQueue()
    var movies: [Movie]?    
    var page = 0
    var requestFunction: MovieListRequestFunction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.movieDelegate = self
        self.requestFunction = queue.popularMovies
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshWithIndicator()
    }
    
    func refreshWithIndicator() {
        mainView.setLoadingScreen(navigationController: navigationController)
        self.refresh { [weak self] () in
            guard let weakSelf = self else { return }
            weakSelf.mainView.removeLoadingScreen()
        }
    }

    func loadNextPage(requestFunction: MovieListRequestFunction, nextPageCompletion: @escaping NextPageCompletion) {
        page+=1
        requestFunction( ["page": page]) { [weak self] (completion) in
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
    
    func loadNextPage(nextPageCompletion: @escaping NextPageCompletion) {
        if let requestFunction = self.requestFunction {
            self.loadNextPage(requestFunction: requestFunction, nextPageCompletion: nextPageCompletion)
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            navigationItem.title = "Popular Movies"
            self.requestFunction = queue.popularMovies
        default:
            navigationItem.title = "Upcoming Movies"
            self.requestFunction = queue.upcomingMovies
        }
        refreshWithIndicator()
    }
}

extension MovieListViewController: MovieListViewDelegate {
    
    func refresh(completion: @escaping () -> Void) {
        mainView.movies = []
        page = 0
        loadNextPage {
            completion()
        }
    }
    
    func requestNextPage(completion: @escaping () -> Void) {
        loadNextPage {
            completion()
        }
    }
}
