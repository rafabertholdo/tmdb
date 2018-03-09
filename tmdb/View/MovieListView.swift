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
    weak var delegate: MovieListViewDelegate?
    var refreshControl: UIRefreshControl!
    
    override func awakeFromNib() {
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        collectionView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        if let delegate = self.delegate {
            delegate.refresh { [weak self] () in
                self?.refreshControl.endRefreshing()
            }
        } else {
            self.refreshControl.endRefreshing()
        }
    }
 }
