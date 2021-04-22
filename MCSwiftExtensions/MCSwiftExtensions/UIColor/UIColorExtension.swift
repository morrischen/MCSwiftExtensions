//
//  UIColorExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 取出RGB色碼顏色
    /// - Parameter rgb: rgb 色碼
    public convenience init(rgb: Int) {
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >>  8) / 255.0
        let b = CGFloat( rgb & 0x0000FF       ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// 取出16進制顏色
    /// - Parameters:
    ///   - hex: 16進制, 不輸入#
    ///   - alpha: 透明度, 0~1
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        
        if #available(iOS 13.0, *) {
            
            let scanner = Scanner(string: hex)
            scanner.currentIndex = hex.startIndex
            var rgbValue: UInt64 = 0
            
            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xFF0000) >> 16
            let g = (rgbValue & 0xFF00) >> 8
            let b = rgbValue & 0xFF
            
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: alpha
            )
            
        } else {
            
            // Fallback on earlier versions
            
            var rgb: UInt32 = 0;
            let scanner = Scanner(string: hex)
            scanner.scanHexInt32(&rgb)
            
            let r = CGFloat((rgb & 0xFF0000) >> 16)
            let g = CGFloat((rgb & 0xFF00) >> 8)
            let b = CGFloat(rgb & 0xFF)
            
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: alpha
            )
        }
    }
}
