//
//  MovieCollectionViewCell.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCollectionViewCell: UICollectionViewCell, Identifiable {
    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    /// Updates visual components with the view model data
    ///
    /// - Parameter model: view model
    func setViewModel(_ model: MovieViewModel) {
        title.attributedText = model.title
        if let url = URL(string: model.coverUrl) {
            cover.af_setImage(withURL: url)
        }
    }
}
