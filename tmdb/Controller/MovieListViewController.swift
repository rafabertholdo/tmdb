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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
        mainView.setLoadingScreen(navigationController: navigationController)
        self.refresh { [weak self] () in
            guard let weakSelf = self else { return }
            weakSelf.mainView.removeLoadingScreen()
        }
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
                //let deadlineTime = DispatchTime.now() + .seconds(3)
                //DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    weakSelf.mainView.movies += moviesViewModel
                    nextPageCompletion()
                //}
            } catch {
                
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            navigationItem.title = "Popular Movies"
        default:
            navigationItem.title = "Upcoming Movies"
        }
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
            //let deadlineTime = DispatchTime.now() + .seconds(3)
            //DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                completion()
            //}
        }
    }
}
