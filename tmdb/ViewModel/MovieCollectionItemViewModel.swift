//
//  MovieCollectionItemViewModel.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

struct MovieCollectionItemViewModel {
    
    var title: NSAttributedString
    var coverUrl: String
    
    init?(_ movie: Movie) {
        guard let title = movie.title else {
            return nil
        }
        
        guard let coverUrl = movie.coverUrl else {
            return nil
        }
        
        self.title = NSAttributedString(string: title)
        self.coverUrl = coverUrl
    }
}
