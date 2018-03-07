//
//  MovieListView.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

class MovieListView: UIView, ViewSpinnable {
    var loadingView = UIView()
    var spinner = UIActivityIndicatorView()
    var loadingLabel = UILabel()   
    
    var movies = [MovieViewModel!]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        collectionView.delegate = self
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension MovieListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("cell not found")
        }
        cell.setViewModel(movies[indexPath.row])
        return cell
    }
}
