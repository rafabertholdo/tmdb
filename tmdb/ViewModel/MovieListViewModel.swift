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

class MovieListViewModel: NSObject, ViewModelProtocol {
    typealias MainView = MovieListView
    
    var movies: Variable<[MovieCollectionItemViewModel]> = Variable([])
    weak var delegate: MovieListViewDelegate?
    var disposeBag = DisposeBag()

    func bindTo(_ view: MainView) {
        view.collectionView.delegate = self
        movies.asObservable().bind(to: view.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { _, item, cell in
            cell.setViewModel(item)
        }.disposed(by: disposeBag)
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
