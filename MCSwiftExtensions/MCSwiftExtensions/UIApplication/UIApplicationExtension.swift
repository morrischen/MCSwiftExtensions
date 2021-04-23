//
//  UIApplicationExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation
import UIKit

extension UIApplication {
    
    //MARK: - Functions
    
    /// Version版號
    public class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    /// Build版號
    public class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    /// Version & Build 版號
    public class func versionBuild() -> String {
        
        let version = appVersion(), build = appBuild()
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    
    /// 取得App語系
    public class func appLanguage() -> String {
        return Locale.current.languageCode!
    }
    
    /// 取得裝置語系
    public class func deviceLanguage() -> String {
        return String(Locale.preferredLanguages.first!)
    }
    
    /// 取得簡短裝置語系(只取前面)
    public class func deviceTinyLanguage() -> String? {
        
        guard var splits = Locale.preferredLanguages.first?.split(separator: "-"), let first = splits.first else { return nil }
        
        guard 1 < splits.count else { return String(first) }
        
        splits.removeLast()
        
        return String(splits.joined(separator: "-"))
    }
}
