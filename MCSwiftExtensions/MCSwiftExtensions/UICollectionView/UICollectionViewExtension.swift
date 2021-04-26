//
//  UICollectionViewExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/26.
//

import Foundation
import UIKit

extension UICollectionReusableView {

    public static var identifier: String {
        return className
    }
}

extension UICollectionView {

    //MARK: - Functions
    
    /// 初始化自定義 Cell
    /// - Parameter cellType: Cell Class Name
    func registerCustomCell<T: UICollectionViewCell>(_ cellType: T.Type) -> Void {
        register(UINib(nibName: T.identifier, bundle: nil), forCellWithReuseIdentifier: T.identifier)
    }

    /// 初始化自定義 HeaderView
    /// - Parameter viewType: HeaderView Class Name
    func registerCustomReusableHeaderView<T: UICollectionReusableView>(_ viewType: T.Type) -> Void {
        register(UINib(nibName: T.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader ,withReuseIdentifier: T.identifier)
    }
    
    /// 初始化自定義 FooterView
    /// - Parameter viewType: FooterView Class Name
    func registerCustomReusableFooterView<T: UICollectionReusableView>(_ viewType: T.Type) -> Void {
        register(UINib(nibName: T.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter ,withReuseIdentifier: T.identifier)
    }
    
    /// 初始化自定義 SupplementaryView
    /// - Parameter viewType: SupplementaryView Class Name
    func registerCustomSupplementaryView<T: UICollectionReusableView>(_ viewType: T.Type) -> Void {
        register(T.self, forSupplementaryViewOfKind: T.identifier, withReuseIdentifier: T.identifier)
    }

    /// 實作自定義 Cell
    /// - Parameters:
    ///   - cellType: Cell Class Name
    ///   - indexPath: IndexPath
    /// - Returns: Cell View
    func dequeueReusableCustomCell<T: UICollectionViewCell>(with cellType: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    /// 實作自定義 HeaderView
    /// - Parameters:
    ///   - cellType: HeaderView Class Name
    ///   - indexPath: IndexPath
    /// - Returns: HeaderView
    func dequeueReusableCustomHeaderView<T: UICollectionReusableView>(with cellType: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    /// 實作自定義 FooterView
    /// - Parameters:
    ///   - cellType: FooterView Class Name
    ///   - indexPath: IndexPath
    /// - Returns: FooterView
    func dequeueReusableCustomFooterView<T: UICollectionReusableView>(with cellType: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 實作自定義 SupplementaryView
    /// - Parameters:
    ///   - cellType: SupplementaryView Class Name
    ///   - indexPath: IndexPath
    /// - Returns: SupplementaryView
    func dequeueReusableCustomSupplementaryView<T: UICollectionReusableView>(with cellType: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: T.identifier, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
