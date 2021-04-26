//
//  UILabelExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation
import UIKit

extension UILabel {
    
    //MARK: - Functions
    
    /// 設定UILabel 文字/文字顏色
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setLabel(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17)) -> Void {
        
        self.font = font
        self.text = text
        self.textColor = color
    }
    
    /// 設定區段文字顏色
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - start: 起始位置
    ///   - offset: 長度
    public func setAttributedText(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17), start: Int, offset: Int) -> Void {
        
        let attrString = NSMutableAttributedString.init(string: text)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(start, offset))
        attrString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(start, offset))
        self.attributedText = attrString
    }
    
    /// 設定下底線文字
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    public func setAttributedUnderLineText(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17), start: Int, offset: Int) -> Void {
        
        let attrString = NSMutableAttributedString.init(string: text)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(start, offset))
        attrString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(start, offset))
        attrString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(start, offset))
        
        self.attributedText = attrString
    }
}
