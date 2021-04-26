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
    public func blur(withStyle style: UIBlurEffect.Style = .light) -> Void {
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        // for supporting device rotation
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        clipsToBounds = true
    }
}
