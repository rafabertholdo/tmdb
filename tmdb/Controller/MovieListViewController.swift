//
//  MovieListViewController.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias NextPageCompletion = () -> Void

class MovieListViewController: UIViewController, ViewCustomizable {
    typealias MainView = MovieListView
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let queue = TMDBOperationQueue()
    var page = 0
    var viewModel = MovieListViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.bindTo(mainView)
        viewModel.segmentedControlIndex.asObservable().bind(to: segmentedControl.rx.selectedSegmentIndex).disposed(by: disposeBag)
        segmentedControl.rx.selectedSegmentIndex.bind(to: viewModel.segmentedControlIndex).disposed(by: disposeBag)
        viewModel.navigationTitle.asObservable().bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        self.mainView.delegate = self
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshWithIndicator()
    }
    
    func refreshWithIndicator() {
        mainView.setLoadingScreen(navigationController: navigationController)
        self.refresh { [weak self] () in            
            self?.mainView.removeLoadingScreen()
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
                
                let moviesViewModel = result.map { (movie) -> MovieCollectionItemViewModel? in
                    guard let viewModel = MovieCollectionItemViewModel(movie) else {
                        return nil
                    }
                    return viewModel
                    }.flatMap { $0 }
                weakSelf.viewModel.movies.value += moviesViewModel
                nextPageCompletion()
            } catch {
                
            }
        }
    }
    
    func loadNextPage(nextPageCompletion: @escaping NextPageCompletion) {
        if let requestFunction = viewModel.requestFunction.value {
            self.loadNextPage(requestFunction: requestFunction, nextPageCompletion: nextPageCompletion)
        }
    }
}

extension MovieListViewController: MovieListViewDelegate {
    
    func refresh(completion: @escaping () -> Void) {
        viewModel.movies.value = []
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
