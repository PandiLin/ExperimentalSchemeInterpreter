//
//  Interpreter.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/20.
//

import Foundation

indirect enum EvalError: Error{
    case undefinedExperssion
    case undefinedSymbolInEnv(String)
    case failedToParse(ASTParseError)
    case failedToProcessedCall(Result<Any, EvalError>, Result<Any, EvalError>)
    case failedToCalArgsInOpExpr(ASTPattern)
    case unknownOperatorInOpExpr(String)

}

struct Closure{
    var lambdaExpr : LambdaExpr
    var env : Env
}


func evalAST(_ expr: AST, env: Env) -> Result<Any, EvalError>{
    let pattern = expr >>> convertToPatterns(_:)
    
    switch pattern{
    case .success(let pattern):
        return eval(pattern, env: env)
    case .failure(let error):
        return .failure(.failedToParse(error))
    }
}

func eval(_ expr : ASTPattern, env: Env) -> Result<Any, EvalError>{
    switch expr{
        
    case .symbol(let str):
        if let value = env.lookup(str){
            return .success(value)
        }
        else{
            return .failure(.undefinedSymbolInEnv(str))
        }
        
    case .number(let num):
        return .success(num)
        
    case .lambdaExpr(let lambdaExpr):
        return .success(Closure(lambdaExpr: lambdaExpr, env: env))
        
    case .letExpr(let args, let argExprs):
        var newEnv : Env = env
        
        for pairDict in args{
            let name = pairDict.0
            let value = evalAST(pairDict.1, env: env)
            
            switch value{
            case .success(let v):
                newEnv = newEnv.extend(name: name, value: v)
            case .failure(let e):
                return .failure(e)
            }
        }
        
        return evalAST(argExprs, env: newEnv)
    case .callExpr(let e1, let e2):
        let value1 = evalAST(e1, env: env)
        let value2 = evalAST(e2, env: env)
        
        
        if case .success(let v1) = value1,
           case .success(let v2) = value2,
           let closure = v1 as? Closure{
             /// here only consider lambda expression with single argsand single value
            return evalAST(closure.lambdaExpr.expr,
                           env: env.extend(name: closure.lambdaExpr.names[0],
                                           value: v2))
            }
        else{
            return .failure(.failedToProcessedCall(value1, value2))
        }

    case .operatorExpr(let opts, let e1, let e2):
        let value1 = evalAST(e1, env: env)
        let value2 = evalAST(e2, env: env)
        
        if case .success(let v1) = value1,
           case .success(let v2) = value2,
           let n1 = v1 as? Double,
           let n2 = v2 as? Double{
            switch opts{
            case "+":
                return .success(n1 + n2)
            case "-":
                return .success(n1 - n2)
            case "*":
                return .success(n1 * n2)
            case "/":
                return .success(n1 / n2)
                
            default:
                return .failure(.unknownOperatorInOpExpr(opts))
            }
        }
        else{
            return .failure(.failedToCalArgsInOpExpr(expr))
        }

    }
}
