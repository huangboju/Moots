//
//  Result.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 1/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation


/// A light-weight version of `Result<T>` for the purpose of this project

enum Result<T> {
    case Success(T)
    case Failure(Error)
}
extension Result {
    /// conversion to Swift2 throw model
    func resolve() throws -> T {
        switch self {
        case Result.Success(let value): return value
        case Result.Failure(let error): throw error
        }
    }
    
    /// conversion from Swift2 throw model
    mutating func build( somethingThatThrows: () throws -> T) {
        do {
            let value = try somethingThatThrows()
            self = Result.Success(value)
        } catch let error {
            self = Result.Failure(error)
        }
    }
}
extension Result {
    func map<U>(transform: (T) -> U) -> Result<U> {
        switch self {
        case .Success(let value): return .Success(transform(value))
        case .Failure(let error): return .Failure(error)
        }
    }
    func flatMap<U>(transform: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .Success(let value): return transform(value)
        case .Failure(let error): return .Failure(error)
        }
    }
}

