
import Foundation
import SwiftUI
import UIKit

extension CGPoint: Equatable{
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

//extension CGPoint Vector Math
extension CGPoint {
    func add(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }

    func subtract(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }

    func multiply(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x * point.x, y: self.y * point.y)
    }

    func divide(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x / point.x, y: self.y / point.y)
    }

    func add(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + value, y: self.y + value)
    }

    func subtract(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x - value, y: self.y - value)
    }

    func multiply(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * value, y: self.y * value)
    }

    func divide(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x / value, y: self.y / value)
    }

    func scaleBy(center: CGPoint, scale: CGFloat) -> CGPoint{
        return CGPoint(x: (self.x - center.x) * scale + center.x, y: (self.y - center.y) * scale + center.y)
    }

    func translateBy(_ translation: CGPoint) -> CGPoint{
        return CGPoint(x: self.x + translation.x, y: self.y + translation.y)
    }

    func distanceVector(to point: CGPoint) -> CGPoint{
        return CGPoint(x:  self.x - point.x, y:  self.y - point.y)
    }
    
    func magSq() -> CGFloat{
        return x*x + y*y
    }
    
    func limit(max: CGFloat) -> CGPoint{
        if (self.magSq() > max * max){
            let dir = self.normalized()
            return dir.multiply(max)
        }
        else {
            return self
        }
    }
    
    
    func length() -> CGFloat{
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint{
        let length = length()
        if (length > 0){
            return self.divide(length)
        }
        else{
            return .zero
        }
    }


    func toString() -> String{
        NSCoder.string(for: self)
    }
    

    // get magnitude

}
