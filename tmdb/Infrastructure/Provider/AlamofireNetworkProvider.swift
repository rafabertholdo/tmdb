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
    func alamofireMethod() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        default:
            return .post
        }
    }
}

class AlamofireNetworkProvider: NetworkProviderProtocol {
    public static let instance = AlamofireNetworkProvider()
    
    func request(_ url: String, method: ServiceHTTPMethod, completion: @escaping NetworkCallback) {
        self.request(url, method: method, parameters: [:], completion: completion)
    }
    
    func request(_ url: String, method: ServiceHTTPMethod, parameters: [String: Any], completion: @escaping NetworkCallback) {
        Alamofire.request(url, method: method.alamofireMethod(), parameters: parameters).responseData { (response) in
            completion { try self.handleReponse(response) }
        }
    }
    
    /// Tratamento da resposta da api
    ///
    /// - Parameter response: reponsta da api
    /// - Returns: dados do retorndo quando não há erros
    /// - Throws: erros da api
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
