//
//  ArrayExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/26.
//

import Foundation

extension Array where Element: Encodable {
    
    //MARK: - Encodable Parameters
    
    public var toJsonString: String? {
        
        return String(data: try! JSONSerialization.data(withJSONObject: self.asDictionaryArray(), options: []), encoding: .utf8)
    }
    
    //MARK: - Encodable Functions
    
    public func asDictionaryArray() throws -> [[String: Any]] {
        
        var data: [[String: Any]] = []

        for element in self {
            data.append(try element.asDictionary())
        }
        
        return data
    }
}

extension Array where Element: Copying {
    
    //MARK: - Copying Functions
    
    func clone() -> Array {
        
        var copiedArray = Array<Element>()
        
        for element in self {
            copiedArray.append(element.copy())
        }
        
        return copiedArray
    }
}
