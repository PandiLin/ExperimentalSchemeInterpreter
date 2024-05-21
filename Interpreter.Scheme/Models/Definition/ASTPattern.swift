//
//  AstPattern.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/21.
//

import Foundation


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
    case callExpr(AST, AST)
    case operatorExpr(String, AST, AST)
}



func convertAtom(_ str: String) ->  Result<ASTPattern, ASTParseError>{
    if let db = Double(str){
        return  .success(ASTPattern.number(db))
    }
    else{
        return  .success(ASTPattern.symbol(str))
    }
}


enum ASTParseError: Error{
    case misformated(String, AST)
    case unknownExpression(AST)
}


func convertToPatterns(_ ast: AST) -> Result<ASTPattern, ASTParseError>{
    switch ast{
    case .atom(let string):
        return convertAtom(string)
    case .list(let ASTs):
        switch ASTs.count{
        case 2:
            return .success(.callExpr(ASTs[0], ASTs[1])
)
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
                                return .failure(.misformated("lambda args", ast))
                            }
                        }
                        return  LambdaExpr(names: processedNames, expr: thirdArgs)
                                >>> {.lambdaExpr($0)}
                                >>> {.success($0)}
                        
                    }
                    else{
                        return .failure(.misformated("lambda args not list", ast))
                    }
                    
                    

                case "let":
                    if case .list(let assigns) = secondArgs{
                        
                        var assignedDict : [(String, AST)] = []
                        
                        for assign in assigns{
                            guard case .list(let dict) = assign,
                                  dict.count == 2 else {
                                return  .failure(.misformated("let assigned value", ast))
                            }
                            
                            guard case .atom(let name) = dict[0] else{
                                return .failure(.misformated("name in let expression is not single symbol", ast))
                            }
                            
                            let value = dict[1]
                            assignedDict.append((name, value))
                        }
                        return .letExpr(assignedDict, thirdArgs) >>> {.success($0)}
                    }
                    else{
                        return .failure(.misformated("second args in let expression", ast))
                    }
                    
                   
                default:
                        return .operatorExpr(str, secondArgs, thirdArgs) >>> {.success($0)}
                }
            }
            else{
                return  .failure(.unknownExpression(ast))
            }
                
            
            
        default:
            return .failure(.unknownExpression(ast))
        }
    }
}




