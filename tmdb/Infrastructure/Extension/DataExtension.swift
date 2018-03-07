//
//  DataExtension.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

extension Data {
    func toDictionary() throws -> NSDictionary {
        guard let searchDictionary = try JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? NSDictionary else {
            throw TecnicalError.invalidDataConvertionToDictionary
        }
        return searchDictionary
    }
}
