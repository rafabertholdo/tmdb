//
//  BaseOperationQueue.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

class BaseOperationQueue: OperationQueue {
    
    /// Initialize an BaseOperationQueue subclass.
    ///
    /// - Parameter maxConcurrentOperationCount: maximun number of concurrent operations.
    convenience init(maxConcurrentOperationCount: Int) {
        self.init()
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    deinit {
        cancelAllOperations()
    }
}
