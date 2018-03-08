//
//  MovieListViewModel.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 08/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias MovieListRequestFunction = ([String: Any], @escaping MovieListCallback) -> Void

class MovieListViewModel: NSObject, ViewModelProtocol {
    typealias MainView = MovieListView
    
    var mainView: MainView?
    weak var delegate: MovieListViewDelegate?
    
    var movies: Variable<[MovieCollectionItemViewModel]> = Variable([])
    var segmentedControlIndex: Variable<Int> = Variable(0)
    var navigationTitle: Variable<String> = Variable("Popular Movies")
    var isLoading: Variable<Bool> = Variable(false)
    var requestFunction: Variable<MovieListRequestFunction?> = Variable(nil)
    
    private var disposeBag = DisposeBag()
    private let queue = TMDBOperationQueue()
    
    override init() {
        super.init()
        
        self.requestFunction.value = queue.popularMovies
        segmentedControlIndex.asObservable().subscribe(onNext: { [weak self] (index) in
                switch index {
                case 0:
                    self?.navigationTitle.value = "Popular Movies"
                    self?.requestFunction.value = self?.queue.popularMovies
                default:
                    self?.navigationTitle.value = "Upcoming Movies"
                    self?.requestFunction.value = self?.queue.upcomingMovies
                }
                self?.refreshWithIndicator()
        }).disposed(by: disposeBag)
        
        isLoading.asObservable().subscribe(onNext: { [weak self] (loading) in
            if loading {
                self?.mainView?.setLoadingScreen()
            } else {
                self?.mainView?.removeLoadingScreen()
            }
        }).disposed(by: disposeBag)
    }
    
    func refreshWithIndicator() {
        isLoading.value = true
        if let delegate = self.delegate {
            delegate.refresh { [weak self] () in
                self?.isLoading.value = false
            }
        }
    }
    
    func bind(to view: MainView) {
        self.mainView = view
        view.collectionView.delegate = self
        view.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        movies.asObservable().bind(to: view.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { _, item, cell in
            cell.setViewModel(item)
        }.disposed(by: disposeBag)
    }
    
    @objc func refresh() {
        if let delegate = self.delegate {
            delegate.refresh { [weak self] () in
                self?.mainView?.refreshControl.endRefreshing()
            }
        } else {
            self.mainView?.refreshControl.endRefreshing()
        }
    }
}

extension MovieListViewModel: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.movies.value.count - 1 {
            if let delegate = self.delegate {
                delegate.requestNextPage {
                }
            }
        }
    }
}
