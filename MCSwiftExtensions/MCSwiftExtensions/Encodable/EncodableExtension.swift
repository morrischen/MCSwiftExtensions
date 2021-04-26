//
//  EncodableExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/26.
//

import Foundation

extension Encodable {

    //MARK: - Functions
    
    public func asDictionary() throws -> [String: Any] {
        
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
