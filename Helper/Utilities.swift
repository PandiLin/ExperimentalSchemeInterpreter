//
// Created by 林潘迪 on 2023/1/3.
//

import Foundation
import SwiftUI
import Vision




extension CVPixelBuffer {
    func toUIImage() -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: self)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        let image = UIImage(cgImage: cgImage)
        return image
    }

    func toImageData(compressionQuality: CGFloat = 1.0) -> Data? {
        guard let image = self.toUIImage() else { return nil }
        return image.jpegData(compressionQuality: compressionQuality)
    }
}


extension CGRect{
    func toCGSize() -> CGSize{
        return CGSize(width: self.width, height: self.height)
    }
}

extension Color{
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0x00ff00) >> 8
        let b = rgbValue & 0x0000ff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}


extension CGRect{
    func toSize() -> CGSize{
        return CGSize(width: self.width, height: self.height)
    }
}

extension CGSize{
    func scaleBy(_ scale: CGFloat) -> CGSize{
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
    
    func scaleBy(_ factor: CGPoint) -> CGSize{
        return CGSize(width: self.width * factor.x, height: self.height * factor.y)
    }
    
    func scaleBy(_ x: CGFloat, _ y: CGFloat) -> CGSize{
        return CGSize(width: self.width * x, height: self.height * y)
    }
    
}

extension CGFloat{
    func mapRange(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let fromLength = from.upperBound - from.lowerBound
        let toLength = to.upperBound - to.lowerBound
        let fromZero = self - from.lowerBound
        let toZero = fromZero * toLength / fromLength
        return toZero + to.lowerBound
    }

    func mapRange(from: (Float, Float), to : (Float, Float)) -> CGFloat {
        let fromLength = from.1 - from.0
        let toLength = to.1 - to.0
        let fromZero = self - CGFloat(from.0)
        let toZero = fromZero * CGFloat(toLength) / CGFloat(fromLength)
        return toZero + CGFloat(to.0)
    }
}


extension CGFloat {
    func toInt() -> Int{
        return Int(self)
    }
}


extension Int{

    func floor(float: CGFloat) -> Int{
        return Int(CGFloat(self).rounded(.down))
    }

    func ceil(float: CGFloat) -> Int{
        return Int(CGFloat(self).rounded(.up))
    }

    func round(float: CGFloat) -> Int{
        return Int(CGFloat(self).rounded(.toNearestOrAwayFromZero))
    }


    func integerQuotientOf(numerator: CGFloat, denominator: CGFloat) -> Int{
        return  Int((numerator / denominator * self.toCGFloat()).rounded(.up))
    }

    func toCGFloat() -> CGFloat{
        return CGFloat(self)
    }

}


extension CGFloat{
    func constraintSet(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat{
        if value < min{
            return min
        }else if value > max{
            return max
        }else{
            return value
        }
    }

    func abs() -> CGFloat{
        if self < 0{
            return -self
        }else{
            return self
        }
    }

    func constraint(min: CGFloat, max: CGFloat) -> CGFloat{
        if self < min{
            return min
        }else if self > max{
            return max
        }else{
            return self
        }
    }
}


