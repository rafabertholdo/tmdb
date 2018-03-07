//
//  ApiError.swift
//  tmdb
//
//  Created by Rafael Guilherme Bertholdo on 07/03/18.
//  Copyright © 2018 Rafael Guilherme Bertholdo. All rights reserved.
//

import Foundation

public enum ApiError: Error {
    case invalidParams(String?)
    case failure(Error, statusCode: Int)
    case invalidReponse(statusCode: Int)
    case connectionFailure
    case emptyResponse
    case unknownError(statusCode: Int)
    case clientOrServerError(statusCode: Int, data: Data)
}
