//
//  NSObjectExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation

extension NSObject {
    
    //MARK: - Parameters
    public class var className: String {
        return String(describing: self.self)
    }
}
