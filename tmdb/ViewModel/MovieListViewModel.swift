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

class MovieListViewModel {
   
    var movies = Variable<[MovieCollectionItemViewModel]>([])
    var segmentedControlIndex = Variable<Int> (0)
    var navigationTitle = Variable<String>("Popular Movies")
    var requestFunction = Variable<MovieListRequestFunction?>(nil)

    private var disposeBag = DisposeBag()
    private let queue = TMDBOperationQueue()
    
    init() {
        self.requestFunction.value = queue.popularMovies
    }
    
    func subcribeToUi(segmentedControl: Observable<Int>) {
        segmentedControl.subscribe(onNext: { [weak self] (index) in
            switch index {
            case 0:
                self?.navigationTitle.value = "Popular Movies"
                self?.requestFunction.value = self?.queue.popularMovies
            default:
                self?.navigationTitle.value = "Upcoming Movies"
                self?.requestFunction.value = self?.queue.upcomingMovies
            }            
        }).disposed(by: disposeBag)
    }
}
