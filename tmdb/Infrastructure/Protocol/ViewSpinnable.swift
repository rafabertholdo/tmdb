//
//  ViewSpinnable.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

protocol ViewSpinnable {
    var loadingView: UIView { get }
    var spinner: UIActivityIndicatorView { get }
    var loadingLabel: UILabel { get }
}

protocol ViewSpinnableDelegate: class {
    func willSetLoadingScreen()
    func didRemoveLoadingScreen()
}

extension ViewSpinnable where Self: UIView {
    
    internal func setLoadingScreen(navigationController: UINavigationController? = nil) {
        setLoadingScreen(view: self, navigationController: navigationController)
    }    
    
    /// Insert an activity indicator to the center of the passed View
    ///
    /// - Parameters:
    ///   - view: View to add the activity indicator
    ///   - navigationController: Navigation controller to subtract the it's height
    internal func setLoadingScreen(view: UIView, navigationController: UINavigationController? = nil) {
        if let spinnableSelf = self as? ViewSpinnableDelegate {
            spinnableSelf.willSetLoadingScreen()
        }
        
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (view.frame.width / 2) - (width / 2)
        let y = (view.frame.height / 2) - (height / 2) - (navigationController != nil ? (navigationController?.navigationBar.frame.height)! : 0)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if !view.subviews.contains(loadingView) {
            loadingView.addSubview(spinner)
            loadingView.addSubview(loadingLabel)
            
            view.addSubview(loadingView)
        }
        spinner.startAnimating()
        loadingLabel.isHidden = false
    }
    
    /// Remove the loading screen from the view
    internal func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        if let spinnableSelf = self as? ViewSpinnableDelegate {
            spinnableSelf.didRemoveLoadingScreen()
        }
    }
}
