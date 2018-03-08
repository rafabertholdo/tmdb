//
//  ViewCustomizable.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

protocol ViewCustomizable {
    associatedtype MainView
}

extension ViewCustomizable where Self: UIViewController {
    var mainView: MainView {
        guard let mainView = self.view as? MainView else {
            fatalError("class not found")
        }
        return mainView
    }
}
