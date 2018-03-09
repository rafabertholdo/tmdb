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

class MovieListViewController: UIViewController, ViewCustomizable {
    typealias MainView = MovieListView
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var domain: MovieList!
    var viewModel: MovieListViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        domain = MovieList()
        viewModel = MovieListViewModel()
        bindToUI()
        mainView.collectionView.delegate = self
    }   
    
    func bindToUI() {
        viewModel.requestFunction.asObservable().skip(1)
            .subscribe(onNext: { [weak self] (requestFunction) in
                self?.viewModel.movies.value = []
                self?.loadNextPage(requestFunction: requestFunction)
        }).disposed(by: disposeBag)
        
        viewModel.movies.asObservable().bind(to: mainView.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { _, item, cell in
            cell.setViewModel(item)
            }.disposed(by: disposeBag)
 
        viewModel.navigationTitle.asObservable().bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        viewModel.subcribeToUi(segmentedControl: segmentedControl.rx.selectedSegmentIndex.asObservable())
    }
    
    func loadNextPage(requestFunction: MovieListRequestFunction?) {
        if let requestFunction = requestFunction {
            mainView.setLoadingScreen(navigationController: navigationController)
            domain.loadNextPage(requestFunction: requestFunction, nextPageCompletion: nextPageCompletion)
        }
    }
    
    func nextPageCompletion(_ nextPageCompletion: () throws -> [Movie]) {
        defer {
            self.mainView.removeLoadingScreen()
        }
        do {
            let result = try nextPageCompletion()
            let moviesViewModel = result.map { (movie) -> MovieCollectionItemViewModel? in
                guard let viewModel = MovieCollectionItemViewModel(movie) else {
                    return nil
                }
                return viewModel
                }.flatMap { $0 }
            
            viewModel.movies.value += moviesViewModel
            self.mainView.removeLoadingScreen()
        } catch {
            
        }
    }
}

extension MovieListViewController: MovieListViewDelegate, UICollectionViewDelegate {
    
    func refresh(completion: @escaping () -> Void) {
        viewModel.movies.value = []
        if let requestFunction = viewModel.requestFunction.value {
            mainView.setLoadingScreen(navigationController: navigationController)
            domain.refresh(requestFunction: requestFunction, nextPageCompletion: nextPageCompletion)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.value.count - 1 {
            loadNextPage(requestFunction: viewModel.requestFunction.value)
        }
    }
}
