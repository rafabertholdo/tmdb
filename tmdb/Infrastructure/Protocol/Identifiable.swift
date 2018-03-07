//
//  Identifiable.swift
//  imdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import UIKit

protocol Identifiable: class {}

extension Identifiable where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
