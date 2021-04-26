//
//  CopyingExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/26.
//

import Foundation

protocol Copying {
    init(original: Self)
}

extension Copying {
    
    func copy() -> Self {
        return Self.init(original: self)
    }
}
