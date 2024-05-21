//
//  ContentView.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/16.
//

import SwiftUI

class InterpreterViewModel: ObservableObject{
    init(){
        // Example usage
  
    }
    
    func eval(_ str: String){
        if let ast : AST = tokenize(str) >>> parseTokens(_:){
            let result = convertToPatterns(ast) >>>
            {Interpreter_Scheme.eval($0, env: Env(entities: []))}
            
            switch result{
            case .success(let r):
                print(r)
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        else{
            print("unable to convert string to AST, zero result discovered")
        }
        
  
    }
}



struct ContentView: View {
    var viewModel = InterpreterViewModel()
    @State var code: String = "(let ((x 1)) (+ x 1))"
    
    
    var body: some View {
        VStack {
            TextEditor(text: $code)
            
            Button(action: {viewModel.eval(code)}, label: {
                Text("execute")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
