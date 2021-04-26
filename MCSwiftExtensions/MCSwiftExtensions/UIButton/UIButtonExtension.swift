//
//  UIButtonExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation
import UIKit

extension UIButton {
    
    //MARK: - Functions
    
    /// 設定UIButton 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setButton(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17)) -> Void {
        
        self.titleLabel?.font = font
        self.setTitle(text, for:UIControl.State())
        self.setTitleColor(color, for:UIControl.State())
    }
    
    /// 設定區段文字顏色
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - start: 起始位置
    ///   - offset: 長度
    ///   - state: 狀態
    public func setAttributedText(text: String, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 17), start: Int, offset: Int, state: UIControl.State = .normal) -> Void {
        
        let attrString = NSMutableAttributedString.init(string: text)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(start, offset))
        attrString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(start, offset))
        self.setAttributedTitle(attrString, for: state)
    }

    /// 設定UIButton 右側圖案
    /// - Parameters:
    ///   - image: 圖片
    ///   - textPadding: 與左邊文字間距
    public func setRightImage(image: UIImage, textPadding:CGFloat) -> Void {
        
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: self.frame.size.width - image.size.width, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: textPadding - image.size.width, bottom: 0, right: 0)
        self.titleLabel?.sizeToFit()
    }

    /// 設定UIButton 左側圖案
    /// - Parameters:
    ///   - image: 圖片
    ///   - textPadding: 與右邊文字間距
    public func setLeftImage(image: UIImage, textPadding:CGFloat) -> Void {
        
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: self.frame.size.width - image.size.width)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: textPadding - image.size.width)
        self.titleLabel?.sizeToFit()
    }

    /// 設定按鈕陰影
    /// - Parameters:
    ///   - backgroundColor: 背景顏色
    ///   - backgroundRadius: 背景圓角
    ///   - shadowColor: 陰影顏色
    ///   - shadowRadius: 陰影圓角
    ///   - opacity: 透明度
    public func setShadow(backgroundColor: UIColor, backgroundRadius: CGFloat , shadowColor: UIColor, shadowRadius: CGFloat, opacity: Float) -> Void {
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = backgroundRadius
        self.layer.backgroundColor = backgroundColor.cgColor
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
    }
    
    /// 產生圓形按鈕
    /// - Parameters:
    ///   - width: 寬度
    ///   - height: 高度
    ///   - backgroundColor: 背景顏色
    ///   - borderWidth: 外框寬度
    ///   - borderColor: 外框顏色
    ///   - target: 目標
    ///   - action: 點擊事件
    public class func initCircleButton(width: CGFloat, height: CGFloat, backgroundColor: UIColor, borderWidth: CGFloat, borderColor: UIColor, target: AnyObject, action: Selector) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = (button.frame.height / 2)
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.cgColor
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return button
    }
    
    /// 產生圖案按鈕
    /// - Parameters:
    ///   - width: 寬度
    ///   - height: 高度
    ///   - colorfulImage: 圖案
    ///   - target: 目標
    ///   - action: 點擊事件
    public class func initButtonWithImage(width: CGFloat, height: CGFloat, colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return button
    }
}
