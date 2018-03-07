//
//  BusinessError.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation
enum BusinessError: Error {
    case couldNotParseProperty(String)
}
