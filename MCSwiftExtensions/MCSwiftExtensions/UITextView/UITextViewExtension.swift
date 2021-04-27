//
//  UITextViewExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/26.
//

import Foundation
import UIKit
import UITextView_Placeholder

extension UITextView {
    
    //MARK: - Functions
    
    /// 設定UITextView 文字/文字顏色
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setTextView(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17)) -> Void {
        
        self.font = font
        self.text = text
        self.textColor = color
    }

    /// 設定UITextView Placeholder 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setPlaceholder(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17)) -> Void {
        
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        let placeholder = NSAttributedString(string: text, attributes: attributes)
        self.attributedPlaceholder = placeholder
    }
}
