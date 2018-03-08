//
//  AlamofireNetworkProvider.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation
import Alamofire

extension ServiceHTTPMethod {
    
    /// Converts the generic HTTP method to the AlamoFire HTTP method
    ///
    /// - Returns: AlamoFire HTTP method
    func alamofireMethod() -> HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .put:
            return HTTPMethod.put
        case .delete:
            return HTTPMethod.delete
        case .head:
            return HTTPMethod.head
        }
    }
}

class AlamofireNetworkProvider: NetworkProviderProtocol {
    public static let instance = AlamofireNetworkProvider()
    
    /// Makes a request to server
    ///
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: HTTP Method
    ///   - completion: Closure called at the end of the reqeust
    func request(_ url: String, method: ServiceHTTPMethod, completion: @escaping NetworkCallback) {
        self.request(url, method: method, parameters: [:], completion: completion)
    }
    
    /// Makes a request to server
    ///
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: HTTP Method
    ///   - parameters: Request Parameters
    ///   - completion: Closure called at the end of the reqeust
    func request(_ url: String, method: ServiceHTTPMethod, parameters: [String: Any], completion: @escaping NetworkCallback) {
        Alamofire.request(url, method: method.alamofireMethod(), parameters: parameters).responseData { (response) in
            completion { try self.handleReponse(response) }
        }
    }
    
    /// Reponse Error handling
    ///
    /// - Parameter response: Server's response
    /// - Returns: Data when no errors
    /// - Throws: API errors
    private func handleReponse(_ response: DataResponse<Data>?) throws -> NetworkData! {
        guard let response = response else {
            throw ApiError.emptyResponse
        }
        
        guard let statusCode = response.response?.statusCode else {
            throw ApiError.invalidReponse(statusCode: -1)
        }
        
        guard let data = response.data else {
            throw ApiError.invalidReponse(statusCode: statusCode)
        }
        
        switch statusCode {
        case 200...299:
            return (statusCode, data)
        default:
            throw ApiError.clientOrServerError(statusCode: statusCode, data: data)
        }
    }
}
