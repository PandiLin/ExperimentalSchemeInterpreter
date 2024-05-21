//
//  Interpreter.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/20.
//

import Foundation

indirect enum EvalError: Error{
    case undefinedExperssion
    case undefinedSymbolInEnv
    case failedToParse(String)
    case failedToProcessedCall(Result<Any, EvalError>, Result<Any, EvalError>)
    case failedToCalArgsInOpExpr
    case unknownOperatorInOpExpr
}

struct Closure{
    var lambdaExpr : LambdaExpr
    var env : Env
}

func eval(_ expr : ASTPattern, env: Env) -> Result<Any, EvalError>{
    switch expr{
        
    case .symbol(let str):
        if let value = env.lookup(str){
            return .success(value)
        }
        else{
            return .failure(.undefinedSymbolInEnv)
        }
    case .number(let num):
        return .success(num)
    case .lambdaExpr(let lambdaExpr):
        return .success(Closure(lambdaExpr: lambdaExpr, env: env))
    case .letExpr(let args, let argExprs):
        var newEnv : Env = env
        
        for pairDict in args{
            let name = pairDict.0
            let value = eval(pairDict.1 >>> convertToPatterns(_:),
                             env: env)
            
            switch value{
            case .success(let v):
                newEnv = newEnv.extend(EnvEntities(name: name, value: v))
            case .failure(let e):
                return .failure(e)
            }
        }
        
        return eval(argExprs >>> convertToPatterns(_:),
                    env: newEnv)
    case .callExpr(let e1, let e2):
        let value1 = eval(e1 >>> convertToPatterns(_:), env: env)
        let value2 = eval(e2 >>> convertToPatterns(_:), env: env)
        
        
        if case .success(let v1) = value1,
           case .success(let v2) = value2,
           let closure = v1 as? Closure{
             /// here only consider lambda expression with single argsand single value
            return eval(closure.lambdaExpr.expr >>> convertToPatterns(_:),
                        env: env.extend(EnvEntities(name: closure.lambdaExpr.names[0],
                                                    value: v2)))
            }
        else{
            return .failure(.failedToProcessedCall(value1, value2))
        }

    case .operatorExpr(let opts, let e1, let e2):
        let value1 = eval(e1 >>> convertToPatterns(_:), env: env)
        let value2 = eval(e2 >>> convertToPatterns(_:), env: env)
        
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
                return .failure(.unknownOperatorInOpExpr)
            }
        }
        else{
            return .failure(.failedToCalArgsInOpExpr)
        }
        
    case .failed(let ast, let reason):
        return .failure(.failedToParse(reason))
    }
}
