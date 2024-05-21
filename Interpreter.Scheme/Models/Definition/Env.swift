//
//  Env.swift
//  Interpreter.Scheme
//
//  Created by apple on 2024/5/20.
//

import Foundation


struct EnvEntities{
    var name: String
    var value: Any
}

struct Env{
    var entities: [EnvEntities]
    
    func lookup(_ name : String) -> Any?{
        for entity in self.entities{
            if entity.name == name{
                return entity.value
            }
        }
        return nil
    }
    
    func extend(_ entity: EnvEntities) -> Env{
        var copy = self.entities
        copy.insert(entity, at: 0)
        return Env(entities: copy)
    }
    
    func extend(name: String, value: Any) -> Env{
        self.extend(EnvEntities(name: name, value: value))
    }
}
