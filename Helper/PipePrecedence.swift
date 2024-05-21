//
//  Monad.swift
//  Toe
//
//  Created by apple on 2023/7/11.
//

import Foundation



    
precedencegroup PipePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}
infix operator >>> : PipePrecedence
func >>> <A,B>(x:A, f:(A) -> B) -> B {
    return f(x)
}

    
/// usage: let avgNuts = squirrels
//    .flatMap { $0.caches }
//    .map {$0.nuts.count}
//    >>> average

/// try to recreate something similar to $ in haskell
