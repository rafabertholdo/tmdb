//
//  MovieListView.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

class MovieListView: UIView, ViewSpinnable {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loadingView = UIView()
    var spinner = UIActivityIndicatorView()
    var loadingLabel = UILabel()

    var refreshControl: UIRefreshControl!
    weak var delegate: MovieListViewDelegate?
    
    override func awakeFromNib() {
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
 
    @objc func refresh() {
        if let movieDelegate = self.delegate {
            movieDelegate.refresh { [weak self] () in                
                self?.refreshControl.endRefreshing()
            }
        } else {
            refreshControl.endRefreshing()
        }
    }
 }
