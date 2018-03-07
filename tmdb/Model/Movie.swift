//
//  Movie.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var title: String?
    var coverUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case coverUrl = "poster_path"
    }
}
