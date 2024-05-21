//
//  AST.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/20.
//

import Foundation


enum AST {
    case atom(String)
    case list([AST])

    func description() -> String {
        switch self {
        case .atom(let value):
            return "Atom(\(value))"
        case .list(let elements):
            let elementsDescriptions = elements.map { $0.description() }
            return "List([\(elementsDescriptions.joined(separator: ", "))])"
        }
    }
}


