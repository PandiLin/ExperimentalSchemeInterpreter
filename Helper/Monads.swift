//
//  Monads.swift
//  swarm
//
//  Created by apple on 2023/12/10.
//

import Foundation
enum TryM<T> {
    case Successful(T)
    case Failure(Error)
    
    init(f : () throws -> T){
        do {
            self = .Successful(try f())
        }
        catch{
            self = .Failure(error)
        }
    }
}


extension TryM {
    func map<U>(f: (T) -> U) -> TryM<U> {
        switch self {
            case .Successful(let value): return .Successful(f(value))
            case .Failure(let error): return .Failure(error)
        }
    }
    
    func flatMap<U>(f: (T) -> TryM<U>) -> TryM<U> {
        switch self {
            case .Successful(let value): return f(value)
            case .Failure(let error): return .Failure(error)
        }
    }
}

enum EmptyDataError: Error {
    case empty
}

