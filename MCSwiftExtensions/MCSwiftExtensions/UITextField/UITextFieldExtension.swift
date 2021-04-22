//
//  UITextFieldExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation
import UIKit

extension UITextField {
    
    /// 設定UITextField 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setTextField(text: String, color: UIColor, font: UIFont = .systemFont(ofSize: 17)) {
        self.font = font
        self.text = text
        self.textColor = color
    }

    /// 設定UITextField Placeholder 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setTextFieldPlaceholder(text: String, color: UIColor, font: UIFont = .systemFont(ofSize: 17)) {
        
        var placeholderString = NSMutableAttributedString()
        placeholderString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        placeholderString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: text.count))
        
        self.attributedPlaceholder = placeholderString
    }

    /// 設定UITextField 下方底線
    /// - Parameters:
    ///   - color: 外框顏色
    ///   - borderWidth: 外框寬度
    public func setTextFieldButtomBorder(color: UIColor, borderWidth: CGFloat) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height:self.frame.size.height)
        border.borderWidth = borderWidth
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    /// 設定UITextField 左側圖案
    /// - Parameters:
    ///   - image: 圖片
    ///   - leftSidePadding: 左邊間距
    ///   - rightSidePadding: 右邊間距
    public func setTextFieldLeftView(image: UIImage, leftSidePadding: CGFloat, rightSidePadding: CGFloat) {
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: (image.size.width) + leftSidePadding + rightSidePadding, height: (image.size.height)))
        
        let iconView  = UIImageView(frame: CGRect(x: leftSidePadding, y: 0, width: image.size.width, height: image.size.height))
        
        iconView.image = image
        leftView.addSubview(iconView)
        
        self.leftView = leftView
        self.leftViewMode = .always
    }
 
    /// 設定UITextField 右側圖案
    /// - Parameters:
    ///   - image: 圖片
    ///   - rightSidePadding: 右邊間距
    public func setTextFieldRightView(image: UIImage, rightSidePadding: CGFloat) {
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: (image.size.width) + rightSidePadding, height: (image.size.height)))
        rightView.addSubview(UIImageView(image: image))
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    /// 設定UITextField 左側間距
    /// - Parameter leftSidePadding: 左邊間距
    public func setTextFieldLeftView(leftSidePadding: CGFloat) {
        
        let leftView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: leftSidePadding,
                                            height: (self.frame.size.height)))
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    /// 設定UITextField 右側間距
    /// - Parameter rightSidePadding: 右邊間距
    public func setTextFieldRightView(rightSidePadding: CGFloat) {
        
        let rightView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: rightSidePadding,
                                             height: (self.frame.size.height)))
        self.rightView = rightView
        self.rightViewMode = .always
    }

    /// 設定UITextField 外框
    /// - Parameters:
    ///   - color: 外框顏色
    ///   - borderWidth: 外框寬度
    ///   - radius: 外框圓角
    public func setTextFieldBorderColor(color:UIColor, borderWidth:CGFloat, radius:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
    }
}
