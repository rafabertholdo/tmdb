//
//  DictionaryExtension.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 08/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation
extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
