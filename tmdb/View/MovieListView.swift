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
    weak var movieDelegate: MovieListViewDelegate?
    var footerSpinner: UIActivityIndicatorView?
    var emptyFooter = UIView()
    var refreshControl: UIRefreshControl!
    
    var movies = [MovieViewModel!]() {
        didSet {
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
         collectionView.delegate = self
    }
 
    @objc func refresh() {
        if let movieDelegate = self.movieDelegate {
            movieDelegate.refresh { [weak self] () in
                guard let weakself = self else { return }
                weakself.refreshControl.endRefreshing()
            }
        } else {
            refreshControl.endRefreshing()
        }
    }
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
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.movies.count - 1 {
            if let movieDelegate = self.movieDelegate {
                movieDelegate.requestNextPage {
                }
            }
        }
    }
}
