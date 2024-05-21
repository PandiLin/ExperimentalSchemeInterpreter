//
//  JsonHelpers.swift
//  Toe
//
//  Created by apple on 2023/7/11.
//

import Foundation
import SwiftUI
import Combine
import UIKit



extension JSONSerialization {
    
    static func loadJSON(withFilename filename: String) throws -> Any? {
        if let path = Bundle.main.url(forResource: filename, withExtension: "json"){
            let data = try Data(contentsOf: path)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        else {
            return nil
        }
    }
    
    static func save(jsonObject: Any, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
    
    static func save(jsonObject: Any, URL: URL) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
 
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: URL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
    
    
}


extension UIImage {
    func toImageDataM() -> TryM<Data> {
        return TryM<Data> {
            try self.toImageData()
        }
    }
    
    func toImageData() throws -> Data{
        guard let imageData = self.jpegData(compressionQuality: 1) else {
            throw NSError(domain: "Unable to convert UIImage to Data", code: -1, userInfo: nil)
        }
        return imageData
    }
}

extension CGImage{
    func liftM() -> TryM<CGImage> {
        return TryM<CGImage> {
            return self
        }
    }
        
    func toUIImage() -> UIImage{
        return UIImage(cgImage: self)
    }
    
    func toBase64M()  -> TryM<String>{
        return self.toUIImage().toImageDataM().map(f: {$0.base64EncodedString()})
    }
    
    func toData() throws -> Data{
        guard let data = self.toUIImage().pngData() else {
            throw NSError(domain: "Unable to convert UIImage to Data", code: -1, userInfo: nil)
        }
        return data
    }
    
    func toDataM() -> TryM<Data>{
        return TryM<Data> {
            try self.toData()
        }
    }
    
    
}



extension String {
    func toJsonData(label: String, process: (([String: String]) -> [String: Any]?)?) throws -> Data {
        let original = [label: self]
        let processedData: [String: Any]

        if let process = process, let processed = process(original) {
            processedData = processed
        } else {
            processedData = original
        }

        let jsonData = try JSONSerialization.data(withJSONObject: processedData, options: [])
        return jsonData
    }

    func toJsonDataM(label: String, process: (([String: String]) -> [String: Any]?)?) -> TryM<Data> {
        return TryM<Data> {
            try self.toJsonData(label: label, process: process)
        }
    }
}


// jsonData now contains the required JSON data.

    



