//
//  AST.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/20.
//

import Foundation


enum AST: Equatable {
    case atom(String)
    case list([AST])
}



