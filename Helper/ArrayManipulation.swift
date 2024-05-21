

extension Array{
    func sortAndReturn(by: (Element, Element) -> Bool) -> Array{
        return self.sorted(by: by)
    }

    func removeDuplicates(by: (Element, Element) -> Bool) -> Array{
        var uniqueArray = Array()
        for element in self{
            if !uniqueArray.contains(where: {by(element, $0)}){
                uniqueArray.append(element)
            }
        } 
        
        return uniqueArray 
    }

  
}


extension Array where Element: Hashable{

    func dropFirstAndReturn() -> [Element]{
        var arrayCopy: Array<Element> = self
        arrayCopy.removeFirst()
        return arrayCopy
    }
    
    func copy() -> Array{
        return self
    }

    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    func takeOnly(_ n: Int) -> Array{

        if n > self.count{
            return self
        }
        else {
            var result = Array()
            for i in 0..<n {
                result.append(self[i])
            }
            return result
        }
    }
    
    
    func remove(_ element: Element) -> Array{
        var arrayCopy: Array<Element> = self
        arrayCopy.removeAll(where: {$0 == element})
        return arrayCopy
    }

    func removeAllAndReturn(_ element: Element) -> Array{
        var arrayCopy: Array<Element> = self
        arrayCopy.removeAll(where: {$0 == element})
        return arrayCopy
    }

    func removeAllAndReturn(_ where: (Element) -> Bool) -> Array{
        var arrayCopy: Array<Element> = self
        arrayCopy.removeAll(where: `where`)
        return arrayCopy
    }
    
    func interactWith(A: Element, Bs: [Element], interact:  (Element, Element) -> Element ) -> Element{
        var iA = A
        for B in Bs{
            iA = interact(iA, B)
        }
        return iA
    }
    
    
    
    
    func interactIterating(before: [Element], after: [Element], current: Element, _ interact : (Element, Element) -> Element, new : [Element])  -> Array{
        if after.isEmpty{
            let interacted = interactWith(A: current, Bs: before, interact: interact)
            return new.appendAndReturn(element: interacted)
        }
        
        else{
            let temp = before + after
            let interacted = interactWith(A: current, Bs: temp, interact: interact)
        
            let nBefore = before.appendAndReturn(element: current)
            let nAfter = after.rest()
            let nCurrent = after.first!
            return  interactIterating(before: nBefore, after: nAfter, current: nCurrent, interact,  new: new.appendAndReturn(element: interacted))
            
        }
    }
    
    func interactMap(_ execute : (Element, Element) -> Element)  -> Array{
        if let first = self.first{
            return  interactIterating(before: [], after: self.rest(), current: first, execute, new: [])
        }
        else{
            return []
        }
   
    }
    
    func rest() -> Array{
        var arrayCopy: Array<Element> = self
        arrayCopy.remove(at: 0)
        return arrayCopy
    }

    //convert array to tuple
    func toTuple() -> (Element, Element){
        return (self[0], self[1])
    }
    
    func appendAndReturn(element: Element) -> Array{
        var arrayCopy: Array<Element> = self
        arrayCopy.append(element)
        return arrayCopy
    }
    
    func appendAndReturn(contentsOf: [Element]) -> Array{
        var arrayCopy: Array<Element> = self
        arrayCopy.append(contentsOf: contentsOf)
        return arrayCopy
    }

    func zip(_ array: Array) -> [(Element, Element)]{
         return Swift.zip(self, array).map{($0, $1)}
    }

    func pick(by: (Element) -> Bool) -> (items: Array, splited: Array){
        var originalCopy: Array<Element> = self
        let item = self.enumerated()
            .filter({(index, item) in  by(item)})
            
        item.forEach({(index, item) in originalCopy.remove(at: index)})

            
        return (items: Array(item.map({(index, item) in item})), splited: originalCopy)
        
    }
    
    func upgrade(element: Element) -> Array{
        let tuple = self.copy().pick(by: {$0 == element})
      
        return tuple.splited.appendAndReturn(element: element)
    }
    
    
    func maxIndex() -> Int{
        return self.count - 1
    }
}




extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Set {
    func interactMap(_ interact: (Element, Element) -> Element) -> Set<Element> {
        var result = Set<Element>()
        for element in self {
            var temp = self
            temp.remove(element)
            let newElement = temp.reduce(element, interact)
            result.insert(newElement)
        }
        return result
    }
}


