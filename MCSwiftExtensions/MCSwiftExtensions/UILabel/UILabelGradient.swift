//
//  UILabelGradient.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation
import UIKit

class UILabelGradient: UILabel {
    
    //MARK: - Enum
    enum direction: String {
        case horizontal = "Horizontal"
        case vertical = "Vertical"
    }

    //MARK: - Parameters
    @IBInspectable var startColor: UIColor = .init(hex: "#ffffff") {
        didSet {
            applyGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor = .init(hex: "#ffffff") {
        didSet {
            applyGradient()
        }
    }
    
    override var text: String? {
        didSet {
            applyGradient()
        }
    }
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        applyGradient()
    }
    
    //MARK: - Function
    
    /// 套用漸層文字
    /// - Parameters:
    ///   - direction: 漸層方向為水平或垂直
    ///   - startColor: 起始顏色
    ///   - endColor: 結束顏色
    internal func applyGradient(direction: direction = .horizontal, startColor: UIColor = .black, endColor: UIColor = .black) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        switch direction {
            
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            break
            
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            break
            
        }
        
        let textSize = NSAttributedString(string: text ?? "", attributes: [.font: font!]).size()
        gradientLayer.bounds = CGRect(origin: .zero, size: textSize)
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, true, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        gradientLayer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        textColor = UIColor(patternImage: image!)
    }
}
