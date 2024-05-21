//import UIKit
//
//enum Pattern {
//    case symbol
//    case number
//    // Add other cases as needed
//}
//
//enum AstPattern {
//    case symbol(String)
//    case number(Int)
//    // Add other cases as needed
//}
//
//struct Exp {
//    let patterns: [Pattern]
//    
//    init(patterns: [Pattern]) {
//        self.patterns = patterns
//    }
//    
//    func match(_ inputs: [AstPattern]) -> MatchResult? {
//        guard patterns.count == inputs.count else {
//            return nil
//        }
//        
//        var matchedValues: [Any] = []
//        
//        for (pattern, input) in zip(patterns, inputs) {
//            switch (pattern, input) {
//            case (.symbol, .symbol(let value)):
//                matchedValues.append(value)
//            case (.number, .number(let value)):
//                matchedValues.append(value)
//            default:
//                return nil
//            }
//        }
//        
//        return MatchResult(matchedValues: matchedValues)
//    }
//}
//
//struct MatchResult {
//    let matchedValues: [Any]
//    
//    func then(_ closure: ([Any]) -> Void) {
//        closure(matchedValues)
//    }
//}
//
//
//extension Exp {
//    static func match(_ patterns: [Pattern]) -> Exp {
//        return Exp(patterns: patterns)
//    }
//}
//
//extension MatchResult {
//    func then(_ closure: (Any...) -> Void) {
//        closure(matchedValues)
//    }
//}
//
//let patterns: [Pattern] = [.symbol, .number]
//let inputs: [AstPattern] = [.symbol("foo"), .number(42)]
//
//if let result = Exp.match(patterns).match(inputs) {
//    result.then { (symbol: Any, number: Any) in
//        if let symbol = symbol as? String, let number = number as? Int {
//            print("Symbol: \(symbol), Number: \(number)")
//            // Perform further processing here
//        }
//    }
//} else {
//    print("Pattern matching failed.")
//}
