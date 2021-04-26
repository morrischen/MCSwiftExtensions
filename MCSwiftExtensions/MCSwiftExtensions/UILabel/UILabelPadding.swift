//
//  UILabelPadding.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//
//  Author Ref: https://gist.github.com/konnnn/d43af3bd525bb4c58f5c29fb14575b0d

import Foundation
import UIKit

public class UILabelPadding: UILabel {
    
    //MARK: - Parameters
    
    var insets = UIEdgeInsets.zero
    
    //MARK: - Functions
    
    public func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}
