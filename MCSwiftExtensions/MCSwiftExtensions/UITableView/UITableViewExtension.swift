//
//  UITableViewExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/26.
//

import Foundation
import UIKit

extension UITableViewCell {

    public static var identifier: String {
        return className
    }
}

extension UITableViewHeaderFooterView {
    
    public static var identifier: String {
        return className
    }
}

extension UITableView {
    
    //MARK: - Parameters
    
    public override var contentSize:CGSize {
        
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    public override var intrinsicContentSize: CGSize {
        
        self.layoutIfNeeded()
        
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    //MARK: - Functions
    
    /// 初始化自定義 Cell
    /// - Parameter cellType: Cell Class Name
    func registerCustomCell<T: UITableViewCell>(_ cellType: T.Type) -> Void {
        register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
    
    /// 初始化自定義 HeaderFooterView
    /// - Parameter viewType: HeaderFooterView Class Name
    func registerCustomReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) -> Void {
        register(UINib(nibName: T.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: T.identifier)
    }
    
    /// 實作自定義 Cell
    /// - Parameter cellType: Cell Class Name
    /// - Returns: Cell View
    func dequeueReusableCustomCell<T: UITableViewCell>(with cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }

    /// 實作自定義 HeaderFooter View
    /// - Parameter cellType: HeaderFooterView Class Name
    /// - Returns: HeaderFooter View
    func dequeueReusableCustomHeaderFooter<T: UITableViewHeaderFooterView>(with cellType: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
    
    /// 捲動UITableView 內容到最上或最底
    /// - Parameters:
    ///   - to: 最上或最底
    ///   - animated: 動畫效果
    func scroll(to: Position, animated: Bool) -> Void {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if rows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
            break
        case .bottom:
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
            break
        }
    }
}
