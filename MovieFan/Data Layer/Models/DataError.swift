//
//  DataError.swift
//  MovieFan
//
//  Created by Rolan on 9/5/22.
//

import Foundation

enum DataError: Error {
    case networkingError(String)
    case coreDataError(String)
}
