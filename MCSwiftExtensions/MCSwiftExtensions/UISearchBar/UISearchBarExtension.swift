//
//  UISearchBarExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation
import UIKit

extension UISearchBar {
    
    public enum ViewSide: String {
        case Left = "Left"
        case Right = "Right"
    }
    
    public var textField: UITextField {
        
        if #available(iOS 13.0, *) {
            return searchTextField
        }
        
        guard let firstSubview = subviews.first else {
            fatalError("Could not find text field")
        }
        
        for view in firstSubview.subviews {
            if let textView = view as? UITextField {
                return textView
            }
        }
        
        fatalError("Could not find text field")
    }
    
    /// 設定UISearchBar Cancel Button 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setCancelButton(text: String, color: UIColor, font: UIFont = .systemFont(ofSize: 17)) {
        
        let barButtonItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        barButtonItem.title = text
        barButtonItem.setTitleTextAttributes([.font: font, .foregroundColor: color], for: .normal)
    }
    
    /// 設定UISearchBar Placeholder 文字/文字顏色/字型
    /// - Parameters:
    ///   - text: 文字
    ///   - color: 文字顏色
    ///   - font: 字型
    public func setSearchBarPlaceholder(text: String, color: UIColor, font: UIFont = .systemFont(ofSize: 17)) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // 直接設定顏色會沒作用, 需要delay
            self.textField.setTextFieldPlaceholder(text: text, color: color, font: font)
        }
    }
    
    /// 設定UISearchBar Placeholder 文字/文字顏色/字型
    /// - Parameters:
    ///   - side: Left  / Right
    ///   - image: 圖片
    ///   - color: 顏色
    public func setSearchBarImage(side: ViewSide = .Left, image: UIImage, color: UIColor) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            let imageView: UIImageView = .init(image: image)
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            
            switch side {
            
            case .Left:
                self.textField.leftView = imageView
                self.textField.leftViewMode = .always
                self.textField.rightView = nil
                self.textField.rightViewMode = .never
                break
                
            case .Right:
                self.textField.leftView = nil
                self.textField.leftViewMode = .never
                self.textField.rightView = imageView
                self.textField.rightViewMode = .always
                break
                
            }
        }
    }
    
    /// 設定UISearchBar為透明背景
    public func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }

        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }
}