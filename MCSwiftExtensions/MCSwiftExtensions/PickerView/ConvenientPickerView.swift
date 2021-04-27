//
//  ConvenientPickerView.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/27.
//

import Foundation
import UIKit

open class ConvenientPickerView: UIView {
    
    public typealias ButtonAction = () -> Void
    public typealias SingleCompleteAction = (_ selectedIndex: Int, _ selectedValue: String) -> Void
    public typealias MultipleCompleteAction = (_ selectedIndexs: [Int], _ selectedValues: [String]) -> Void
    public typealias DateCompleteAction = (_ selectedDate: Date) -> Void
    public typealias MultipleAssociatedDataType = [[[String: [String]?]]]
    
    fileprivate var pickerView: PickerView! = PickerView()
    fileprivate let pickerViewHeight:CGFloat = 260.0
    fileprivate let screenWidth = UIScreen.main.bounds.size.width
    fileprivate let screenHeight = UIScreen.main.bounds.size.height
    fileprivate var hideFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: pickerViewHeight)
    }
    fileprivate var showFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight - pickerViewHeight, width: screenWidth, height: pickerViewHeight)
    }
    
    // MARK: - 初始化
    // 單列
    convenience init(frame: CGRect, toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, okTitle: String = "confirm".localized(), cancelTitle: String = "cancel".localized(), singleColData: [String], defaultSelectedIndex: Int?, completeAction: SingleCompleteAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.singleColPicker(toolBarTitle: toolBarTitle, toolBarTextColor: toolBarTextColor!, toolBarBackgroundColor: toolBarBackgroundColor!, okTitle: okTitle, cancelTitle: cancelTitle, singleColData: singleColData, defaultIndex: defaultSelectedIndex, cancelAction: {[unowned self] in
            // 點擊取消的時候移除
            self.hidePicker()
            
        }, completeAction: {[unowned self] (selectedIndex, selectedValue) in
            completeAction?(selectedIndex, selectedValue)
            self.hidePicker()
            
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 點擊背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    
    // 多列不關聯
    convenience init(frame: CGRect, toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, okTitle: String = "confirm".localized(), cancelTitle: String = "cancel".localized(), multipleColsData: [[String]], defaultSelectedIndexes: [Int]?, completeAction: MultipleCompleteAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.multipleColsPicker(toolBarTitle: toolBarTitle, toolBarTextColor: toolBarTextColor, toolBarBackgroundColor: toolBarBackgroundColor, okTitle: okTitle, cancelTitle: cancelTitle, multipleColsData: multipleColsData, defaultIndexes: defaultSelectedIndexes, cancelAction: {[unowned self] in
            
            // 點擊取消的時候移除
            self.hidePicker()
            
        }, completeAction: {[unowned self] (selectedIndexs, selectedValues) in
            completeAction?(selectedIndexs, selectedValues)
            self.hidePicker()
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 點擊背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    
    // 多列關聯
    convenience init(frame: CGRect, toolBarTitle: String, multipleAssociatedColsData: MultipleAssociatedDataType, defaultSelectedValues: [String]?, completeAction: MultipleCompleteAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.multipleAssociatedCosPicker(toolBarTitle, multipleAssociatedColsData: multipleAssociatedColsData, defaultSelectedValues: defaultSelectedValues, cancelAction: {[unowned self] in
            
            // 點擊取消的時候移除
            self.hidePicker()
            
        }, completeAction: {[unowned self] (selectedIndexs, selectedValues) in
            completeAction?(selectedIndexs, selectedValues)
            self.hidePicker()
        })
        
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 點擊背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    
    // 城市選擇器
    convenience init(frame: CGRect, toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, defaultSelectedValues: [String]?, selectTopLevel: Bool = false, completeAction: MultipleCompleteAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.citiesPicker(toolBarTitle: toolBarTitle,
                                             toolBarTextColor: toolBarTextColor!,
                                             toolBarBackgroundColor: toolBarBackgroundColor!,
                                             defaultSelectedValues: defaultSelectedValues,
                                             selectTopLevel: selectTopLevel,
                                             cancelAction: {[unowned self] in
                                                
                                                // 點擊取消的時候移除
                                                self.hidePicker()
                                                
                                             }, completeAction: {[unowned self] (selectedIndexs, selectedValues) in
                                                completeAction?(selectedIndexs, selectedValues)
                                                self.hidePicker()
                                             })
        
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 點擊背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    
    // 日期選擇器
    convenience init(frame: CGRect, toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, okTitle: String = "confirm".localized(), cancelTitle: String = "cancel".localized(), datePickerSetting: DatePickerSetting, completeAction: DateCompleteAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.datePicker(toolBarTitle: toolBarTitle, toolBarTextColor: toolBarTextColor!, toolBarBackgroundColor: toolBarBackgroundColor!, okTitle: okTitle, cancelTitle: cancelTitle, datePickerSetting: datePickerSetting, cancelAction:  {[unowned self] in
            
            // 點擊取消的時候移除
            self.hidePicker()
            
        }, completeAction: {[unowned self] (selectedDate) in
            completeAction?(selectedDate)
            self.hidePicker()
        })
        
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 點擊背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOrentationObserver()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("ConvenientPickerView deinit")
    }
}

// MARK: - selector
extension ConvenientPickerView {
    
    fileprivate func addOrentationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusBarOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    // 屏幕旋轉時移除pickerView
    @objc func statusBarOrientationChange() {
        removeFromSuperview()
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        
        let location = tap.location(in: self)
        
        // 點擊空白背景移除self
        if location.y <= screenHeight - pickerViewHeight {
            self.hidePicker()
        }
    }
}

// MARK: - 彈出和移除self
extension ConvenientPickerView {
    
    fileprivate func showPicker() {
        
        // 通過window 彈出view
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        guard let currentWindow = window else { return }
        
        currentWindow.addSubview(self)
        
        UIView.animate(withDuration: 0.25, animations: {[unowned self] in
            self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
            self.pickerView.frame = self.showFrame
        }, completion: nil)
    }
    
    func hidePicker() {
        
        // 把self從window中移除
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.backgroundColor = UIColor.clear
            self.pickerView.frame = self.hideFrame
            
        }, completion: {[unowned self] (_) in
            self.removeFromSuperview()
        })
    }
}

// MARK: -  快速使用方法
extension ConvenientPickerView {
    
    /// 單列選擇器
    /// - Parameters:
    ///   - toolBarTitle:           工具列標題
    ///   - toolBarTextColor:       工具列標題文字顏色
    ///   - toolBarBackgroundColor: 工具列背景色
    ///   - okTitle:                確定按鈕文字
    ///   - cancelTitle:            取消按鈕文字
    ///   - data:                   數據
    ///   - defaultSelectedIndex:   預設選中Index
    ///   - completeAction:         確定按鈕 Closure
    public class func showSingleColPicker(toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, okTitle: String = "confirm".localized(), cancelTitle: String = "cancel".localized(), data: [String], defaultSelectedIndex: Int?,  completeAction: SingleCompleteAction?) {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        guard let currentWindow = window else { return }
        
        let convenientPickerView = ConvenientPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, toolBarTextColor: toolBarTextColor, toolBarBackgroundColor: toolBarBackgroundColor, okTitle: okTitle, cancelTitle: cancelTitle, singleColData: data, defaultSelectedIndex: defaultSelectedIndex ,completeAction: completeAction)
        
        convenientPickerView.showPicker()
    }
    
    /// 多列不關聯選擇器
    /// - Parameters:
    ///   - toolBarTitle:           工具列標題
    ///   - toolBarTextColor:       工具列標題文字顏色
    ///   - toolBarBackgroundColor: 工具列背景色
    ///   - okTitle:                確定按鈕文字
    ///   - cancelTitle:            取消按鈕文字
    ///   - data:                   數據
    ///   - defaultSelectedIndexes: 預設選中Indexes
    ///   - completeAction:         確定按鈕 Closure
    public class func showMultipleColsPicker(_ toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, okTitle: String = "confirm".localized(), cancelTitle: String = "cancel".localized(), data: [[String]], defaultSelectedIndexes: [Int]?,completeAction: MultipleCompleteAction?) {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        guard let currentWindow = window else { return }
        
        let convenientPickerView = ConvenientPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, toolBarTextColor: toolBarTextColor, toolBarBackgroundColor: toolBarBackgroundColor, okTitle: okTitle, cancelTitle: cancelTitle, multipleColsData: data, defaultSelectedIndexes: defaultSelectedIndexes, completeAction: completeAction)
        
        convenientPickerView.showPicker()
    }
    
    /// 多列關聯選擇器
    ///
    ///  - parameter title:                      標題
    ///  - parameter data:                       數據, 數據的格式参照示例
    ///  - parameter defaultSeletedIndexs:       默認選中的每一列的行數
    ///  - parameter CompleteAction:             響應完成完成的Closure
    ///
    ///  - returns:
    public class func showMultipleAssociatedColsPicker(_ toolBarTitle: String, data: MultipleAssociatedDataType, defaultSelectedValues: [String]?, completeAction: MultipleCompleteAction?) {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let currentWindow = window else { return }
        
        let testView = ConvenientPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, multipleAssociatedColsData: data, defaultSelectedValues: defaultSelectedValues, completeAction: completeAction)
        
        testView.showPicker()
        
    }
    
    
    /// 城市選擇器
    ///
    ///  - parameter title:                      標題
    ///  - parameter defaultSeletedValues:       默認選中的每一列的值, 注意不是行數
    ///  - parameter CompleteAction:             響應完成完成的Closure
    ///
    ///  - returns:
    public class func showCitiesPicker(_ toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, defaultSelectedValues: [String]?, selectTopLevel: Bool=false, completeAction: MultipleCompleteAction?) {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let currentWindow = window else { return }
        
        let testView = ConvenientPickerView(frame: currentWindow.bounds,
                                            toolBarTitle: toolBarTitle,
                                            toolBarTextColor: toolBarTextColor,
                                            toolBarBackgroundColor: toolBarBackgroundColor,
                                            defaultSelectedValues: defaultSelectedValues,
                                            selectTopLevel: selectTopLevel,
                                            completeAction: completeAction)
        
        testView.showPicker()
        
    }
    
    /// 日期選擇器
    /// - Parameters:
    ///   - toolBarTitle:           工具列標題
    ///   - toolBarTextColor:       工具列標題文字顏色
    ///   - toolBarBackgroundColor: 工具列背景色
    ///   - okTitle:                確定按鈕文字
    ///   - cancelTitle:            取消按鈕文字
    ///   - datePickerSetting:      datePickerSetting
    ///   - completeAction:         確定按鈕 Closure
    public class func showDatePicker(_ toolBarTitle: String, toolBarTextColor: UIColor? = UIColor.black, toolBarBackgroundColor: UIColor? = UIColor.white, okTitle: String = "confirm".localized(), cancelTitle: String = "cancel".localized(), datePickerSetting: DatePickerSetting = DatePickerSetting(), completeAction: DateCompleteAction?) {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        guard let currentWindow = window else { return }
        
        let convenientPickerView = ConvenientPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, toolBarTextColor: toolBarTextColor, toolBarBackgroundColor: toolBarBackgroundColor, okTitle: okTitle, cancelTitle: cancelTitle, datePickerSetting: datePickerSetting, completeAction: completeAction)
        
        convenientPickerView.showPicker()
    }
}
