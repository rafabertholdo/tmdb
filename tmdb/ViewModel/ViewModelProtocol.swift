//
//  ViewModelProtocol.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 08/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

protocol ViewModelProtocol: ViewCustomizable {
    func bind(to view: MainView)
}
