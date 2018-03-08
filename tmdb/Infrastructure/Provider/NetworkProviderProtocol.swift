//
//  NetworkProviderProtocol.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

/// Service HTTP Method
///
/// - get: GET Verb
/// - post: POST Verb
/// - head: HEAD Verb
/// - put: PUT Verb
/// - delete: DELETE Verb
enum ServiceHTTPMethod: String {
    case get
    case post
    case head
    case put
    case delete
}

public typealias NetworkData = (statusCode: Int, data: Data)
public typealias NetworkCallback = (@escaping () throws -> NetworkData!) -> Void

protocol NetworkProviderProtocol {
    
    /// Makes a request to server
    ///
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: HTTP Method
    ///   - completion: Closure called at the end of the reqeust
    func request(_ url: String, method: ServiceHTTPMethod, completion: @escaping NetworkCallback)
    
    /// Makes a request to server
    ///
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: HTTP Method
    ///   - parameters: Request Parameters
    ///   - completion: Closure called at the end of the reqeust
    func request(_ url: String, method: ServiceHTTPMethod, parameters: [String: Any], completion: @escaping NetworkCallback)
}
