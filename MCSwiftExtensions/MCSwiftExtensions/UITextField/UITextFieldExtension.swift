//
//  UITextFieldExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation
import UIKit

extension UITextField {
    
    //MARK: - Functions
    
    /// 設定UITextField 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setTextField(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17)) -> Void {
        
        self.font = font
        self.text = text
        self.textColor = color
    }

    /// 設定UITextField Placeholder 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setPlaceholder(text: String, color: UIColor = .lightGray, font: UIFont = .systemFont(ofSize: 17)) -> Void {
        
        let placeholderString = NSMutableAttributedString(string: text)
        placeholderString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: text.count))
        placeholderString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: text.count))
        
        self.attributedPlaceholder = placeholderString
    }

    /// 設定UITextField 下方底線
    /// - Parameters:
    ///   - color: 外框顏色
    ///   - borderWidth: 外框寬度
    public func setButtomBorder(color: UIColor, borderWidth: CGFloat) -> Void {
        
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
    public func setLeftView(image: UIImage, leftPadding: CGFloat, rightPadding: CGFloat) -> Void {
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: (image.size.width) + leftPadding + rightPadding, height: (image.size.height)))
        
        let iconView  = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: image.size.width, height: image.size.height))
        
        iconView.image = image
        leftView.addSubview(iconView)
        
        self.leftView = leftView
        self.leftViewMode = .always
    }
 
    /// 設定UITextField 右側圖案
    /// - Parameters:
    ///   - image: 圖片
    ///   - padding: 右邊間距
    public func setRightView(image: UIImage, padding: CGFloat) -> Void {
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: (image.size.width) + padding, height: (image.size.height)))
        rightView.addSubview(UIImageView(image: image))
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    /// 設定UITextField 間距
    /// - Parameters:
    ///   - side: 左 / 右 / 全部
    ///   - padding: 間距大小
    public func setPadding(side: ViewSide, padding: CGFloat) -> Void {
        
        switch side {
        
        case .Left:
            
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: (self.frame.size.height)))
            self.leftView = leftView
            self.leftViewMode = .always
            
            break
            
        case .Right:
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: (self.frame.size.height)))
            self.rightView = rightView
            self.rightViewMode = .always
            
            break
            
        default:
            
            let allView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: (self.frame.size.height)))
            
            self.leftView = allView
            self.leftViewMode = .always
            
            self.rightView = allView
            self.rightViewMode = .always

            break
        }
    }
    
    /// 設定UITextField 右側間距
    /// - Parameter rightSidePadding: 右邊間距
    public func setRightPadding(padding: CGFloat) -> Void {
        
        let rightView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: padding,
                                             height: (self.frame.size.height)))
        self.rightView = rightView
        self.rightViewMode = .always
    }
}
