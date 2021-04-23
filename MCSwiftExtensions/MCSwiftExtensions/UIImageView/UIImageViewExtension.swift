//
//  UIImageViewExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    //MARK: - Functions
    
    /// 產生模糊特效
    /// - Parameter style: UIBlurEffectStyle (default is .light)
    public func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
}
