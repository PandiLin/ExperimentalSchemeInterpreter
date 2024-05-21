//
//  AstPattern.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/21.
//

import Foundation


struct LetExprBinds{
    var LetEntity: [(String, AST)]
}

struct LambdaExpr{
    var names: [String]
    var expr: AST
}
// Manually conforming AstPattern to Equatable
enum ASTPattern {
    case symbol(String)
    case number(Double)
    case lambdaExpr(LambdaExpr)
    case letExpr([(String, AST)], AST)
    case failed(AST, String)
    case callExpr(AST, AST)
    case operatorExpr(String, AST, AST)
}

func convertAtom(_ str: String) -> ASTPattern{
    if let db = Double(str){
        return ASTPattern.number(db)
    }
    else{
        return ASTPattern.symbol(str)
    }
}

func convertToPatterns(_ ast: AST) -> ASTPattern{
    switch ast{
    case .atom(let string):
        return convertAtom(string)
    case .list(let ASTs):
        switch ASTs.count{
        case 2:
            return .callExpr(ASTs[0], ASTs[1])
    
        case 3:
            let opExpr = ASTs[0]
            let secondArgs = ASTs[1]
            let thirdArgs = ASTs[2]
            
            if case .atom(let str) = opExpr {
                switch str{
                case "lambda":
                    if case .list(let nameList) = secondArgs{
                        var processedNames : [String] = []
                        for nam in nameList{
                            if case .atom(let n) = nam{
                                processedNames.append(n)
                            }
                            else{
                                return .failed(ast, "lambda args misFormated")
                            }
                        }
                        return .lambdaExpr(LambdaExpr(names: processedNames, expr: thirdArgs))
                        
                    }
                    else{
                        return .failed(ast, "lambda expr misformated")
                    }
                    
                    

                case "let":
                    if case .list(let assigns) = secondArgs{
                        
                        var assignedDict : [(String, AST)] = []
                        
                        for assign in assigns{
                            guard case .list(let dict) = assign,
                                       dict.count == 2 else {
                                return .failed(ast, "let assigned values is not in proper format")
                            }
                            
                            guard case .atom(let name) = dict[0] else{
                                return .failed(ast, "name in let expression is not single symbol")
                            }
                        
                            let value = dict[1]
                            assignedDict.append((name, value))
                        }
                        return .letExpr(assignedDict, thirdArgs)
                    }
                    else{
                        return .failed(ast, "second args in let expression is not in proper format")
                    }
                    
                   
                default:
                    return .operatorExpr(str, secondArgs, thirdArgs)
                }
            }
            else{
                return .failed(ast, "unknown expression with three args")
            }
                
            
            
        default:
            return .failed(ast, "unknown expression")
        }
    }
}




