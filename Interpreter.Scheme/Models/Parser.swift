//
//  Parser.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/20.
//

import Foundation

func tokenize(_ input: String) -> [String] {
    var tokens: [String] = []
    var currentToken = ""
    
    for char in input {
        if char == "(" || char == ")" {
            if !currentToken.isEmpty {
                tokens.append(currentToken)
                currentToken = ""
            }
            tokens.append(String(char))
        } else if char.isWhitespace {
            if !currentToken.isEmpty {
                tokens.append(currentToken)
                currentToken = ""
            }
        } else {
            currentToken.append(char)
        }
    }
    
    if !currentToken.isEmpty {
        tokens.append(currentToken)
    }
    
    return tokens
}


func parseTokens(_ tokens: [String]) -> AST? {
    var index = 0
    
    func parse() -> AST? {
        guard index < tokens.count else { return nil }
        
        // skip the firsy "("
        let token = tokens[index]
        index += 1
        
        if token == "(" {
            var list: [AST] = []
            while tokens[index] != ")" {
                if let sublist = parse() {
                    list.append(sublist)
                }
            }
            index += 1 // Skip the closing ')'
            return .list(list)
        } else if token == ")" {
            // This should not happen if the input is well-formed
            return nil
        } else {
            return .atom(token)
        }
    }
    
    return parse()
}
