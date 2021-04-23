//
//  UIStoryboardExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    //MARK: - Functions
    
    class func controller<T: UIViewController>(storyboard: StoryboardName) -> T {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: T.className) as! T
    }
    
    class func initial<T: UIViewController>(storyboard: StoryboardName) -> T {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController() as! T
    }
}
