//
//  UIViewExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: - Parameters
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowOffset = CGSize.zero
            layer.shadowRadius = newValue
            layer.shadowOpacity = 0.2
        }
    }

    /// 取得view截圖
    public var screenshot: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    //MARK: - Functions
    
    /// 設定UIView 背景圖片
    /// - Parameters:
    ///   - image: 圖片
    ///   - mode: 放大模式
    public func setBackGroundImage(image: UIImage, mode: UIView.ContentMode) -> Void {
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode = mode
        self.insertSubview(backgroundImage, at: 0)
    }

    /// 設定UIView 外框顏色/外框寬度/外框圓角
    /// - Parameters:
    ///   - color: 外框顏色
    ///   - borderWidth: 外框寬度
    ///   - radius: 外框圓角
    public func setBorder(color: UIColor, borderWidth: CGFloat, radius: CGFloat) -> Void {
        
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
    }
    
    /// 設定UIView陰影
    /// - Parameters:
    ///   - shadowColor: 陰影顏色
    ///   - shadowRadius: 陰影圓角
    ///   - opacity: 透明度
    public func setShadow(shadowColor: UIColor, shadowRadius: CGFloat, opacity: Float) -> Void {
                
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = shadowRadius
    }
    
    /// 設定UIView高度
    /// - Parameter height: 高度
    public func setHeightConstraint(height: CGFloat) -> Void {
        
        let constraintAry:Array = self.constraints
        
        for i in 0...constraintAry.count-1 {
            let constraint:NSLayoutConstraint = constraintAry[i]
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = height
            }
        }
    }
    
    /// Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    public func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) -> Void {
        
        if isHidden {
            isHidden = false
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    public func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) -> Void {
        
        if isHidden {
            isHidden = false
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
