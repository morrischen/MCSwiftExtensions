//
//  ToolBarView.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/27.
//

import Foundation
import UIKit

class ToolBarView: UIView {
    
    typealias CustomClosures = (_ titleLabel: UILabel, _ cancelButton: UIButton, _ completeButton: UIButton) -> ()
    
    public typealias ButtonAction = () -> ()
    
    public var completeAction: ButtonAction?
    
    public var cancelAction: ButtonAction?
    
    public var title = "請選擇" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var toolBarTextColor = UIColor.black {
        didSet {
            titleLabel.textColor = toolBarTextColor
            completeButton.setTitleColor(toolBarTextColor, for: .normal)
            cancelButton.setTitleColor(toolBarTextColor, for: .normal)
        }
    }
    
    public var toolBarBackgroundColor = UIColor.white {
        didSet {
            contentView.backgroundColor = toolBarBackgroundColor
        }
    }
    
    public var okTitle = "確認" {
        didSet {
            completeButton.setTitle(okTitle, for: .normal)
        }
    }
    
    public var cancelTitle = "取消" {
        didSet {
            cancelButton.setTitle(cancelTitle, for: .normal)
        }
    }
    
    /// 主題文本框
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    /// 取消按鈕
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    /// 完成按鈕
    private lazy var completeButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    /// 菜單欄
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = UIColor.lightText
        addSubview(contentView)
        
        contentView.addSubview(completeButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(titleLabel)
        completeButton.addTarget(self,
                                 action: #selector(completeButtonOnClick(sender:)),
                                 for: .touchUpInside)
        cancelButton.addTarget(self,
                               action: #selector(cancelButtonOnClick(sender:)),
                               for: .touchUpInside)
    }
    
    @objc func completeButtonOnClick(sender: UIButton) {
        completeAction?()
    }
    
    @objc func cancelButtonOnClick(sender: UIButton) {
        cancelAction?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 15.0
        let contentHeight = bounds.size.height
        contentView.frame = CGRect(x: 0.0,
                                   y: 0.0,
                                   width: bounds.size.width,
                                   height: contentHeight)
        
        let btnWidth: CGFloat = 60
        cancelButton.frame = CGRect(x: margin,
                                    y: 0.0,
                                    width: btnWidth,
                                    height: contentHeight)
        completeButton.frame = CGRect(x: bounds.size.width - btnWidth - margin,
                                      y: 0.0,
                                      width: btnWidth,
                                      height: contentHeight)
        
        let titleStartX = cancelButton.frame.maxX
        let titleEndX = completeButton.frame.minX
        let titleW = titleEndX - titleStartX
        titleLabel.frame = CGRect(x: titleStartX,
                                  y: 0.0,
                                  width: titleW,
                                  height: contentHeight)
    }
}
