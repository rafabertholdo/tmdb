//
//  MovieListViewDelegate.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 08/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation
protocol MovieListViewDelegate: class {
    func refresh(completion:@escaping () -> Void)
}
