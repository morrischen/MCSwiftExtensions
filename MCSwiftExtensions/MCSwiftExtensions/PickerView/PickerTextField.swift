//
//  PickerTextField.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/27.
//

import Foundation
import UIKit

open class PickerTextField: UITextField {
    
    //MARK: - Parameters
    public typealias ButtonAction = () -> Void
    public typealias SingleCompleteAction = (_ textField: UITextField,_ selectedIndex: Int, _ selectedValue: String) -> Void
    public typealias MultipleCompleteAction = (_ textField: UITextField,_ selectedIndexs: [Int], _ selectedValues: [String]) -> Void
    public typealias DateCompleteAction = (_ textField: UITextField,_ selectedDate: Date) -> Void
    public typealias MultipleAssociatedDataType = [[[String: [String]?]]]
    
    // 保存pickerView的初始化
    fileprivate var setUpPickerClosure:(() -> PickerView)?
    
    // 如果設置了autoSetSelectedText為true 將自動設置text的值, 默認以空格分開多列選擇, 但你仍然可以在響應完成的closure中修改text的值
    fileprivate var autoSetSelectedText = false
    
    //MARK: - Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    // 從xib或storyboard中初始化時候調用
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("PickerTextField deinit")
    }
}

// MARK: - 監聽通知
extension PickerTextField {
    
    fileprivate func commonInit() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didBeginEdit),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEndEdit),
                                               name: UITextField.textDidEndEditingNotification,
                                               object: self)
    }
    
    // 開始編輯添加pickerView
    @objc func didBeginEdit()  {
        
        let pickerView = setUpPickerClosure?()
        pickerView?.delegate = self
        inputView = pickerView
    }
    
    // 編輯完成銷毀pickerView
    @objc func didEndEdit() {
        inputView = nil
    }
    
    override open func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}

extension PickerTextField: PickerViewDelegate {
    
    public func singleColDidSelected(_ selectedIndex: Int, selectedValue: String) {
        
        if autoSetSelectedText {
            
            text = " " + selectedValue
        }
    }
    
    public func multipleColsDidSelected(_ selectedIndexs: [Int], selectedValues: [String]) {
        
        if autoSetSelectedText {
            
            text = selectedValues.reduce("", { (result, selectedValue) -> String in
                result + " " + selectedValue
            })
        }
    }
    
    public func dateDidSelected(_ selectedDate: Date) {
        
        if autoSetSelectedText {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let string = formatter.string(from: selectedDate)
            text = " " + string
        }
    }
}

// MARK: - 使用方法
extension PickerTextField {
    
    /// 單列選擇器
    ///
    ///  - parameter title:                      標題
    ///  - parameter data:                       數據
    ///  - parameter defaultSeletedIndex:        默認選中的行數
    ///  - parameter autoSetSelectedText:        設置為true的時候, 將按默認的格式自動設置textField的值
    ///  - parameter completeAction:             響應完成的Closure
    ///
    ///  - returns:
    public func showSingleColPicker(_ toolBarTitle: String,
                                    data: [String],
                                    defaultSelectedIndex: Int?,
                                    autoSetSelectedText: Bool,
                                    completeAction: SingleCompleteAction?) {
        
        self.autoSetSelectedText = autoSetSelectedText
        
        // 保存在這個closure中, 在開始編輯的時候在執行, 避免像之前在這裡直接初始化pickerView, 每個SelectionTextField在調用這個方法的時候就初始化pickerView,當有多個pickerView的時候就很消耗內存
        setUpPickerClosure = {() -> PickerView in
            
            return PickerView.singleColPicker(toolBarTitle: toolBarTitle, singleColData: data, defaultIndex: defaultSelectedIndex, cancelAction: {[unowned self] in
                
                self.endEditing(true)
                
            }, completeAction: {[unowned self] (selectedIndex: Int, selectedValue: String) -> Void in
                
                completeAction?(self, selectedIndex, selectedValue)
                self.endEditing(true)
            })
        }
    }
    
    /// 多列不關聯選擇器
    ///
    ///  - parameter title:                      標題
    ///  - parameter data:                       數據
    ///  - parameter defaultSeletedIndexs:       默認選中的每一列的行數
    ///  - parameter autoSetSelectedText:        設置為true的時候, 將按默認的格式自動設置textField的值
    ///  - parameter completeAction:             響應完成的Closure
    ///
    ///  - returns:
    public func showMultipleColsPicker(_ toolBarTitle: String, data: [[String]], defaultSelectedIndexs: [Int]?, autoSetSelectedText: Bool, completeAction: MultipleCompleteAction?) {
        self.autoSetSelectedText = autoSetSelectedText
        
        setUpPickerClosure = {() -> PickerView in
            
            return PickerView.multipleColsPicker(toolBarTitle: toolBarTitle, multipleColsData: data, defaultIndexes: defaultSelectedIndexs, cancelAction: { [unowned self] in
                
                self.endEditing(true)
                
            }, completeAction:{[unowned self] (selectedIndexs: [Int], selectedValues: [String]) -> Void in
                
                completeAction?(self, selectedIndexs, selectedValues)
                self.endEditing(true)
            })
        }
        
    }
    
    /// 多列關聯選擇器
    ///
    ///  - parameter title:                      標題
    ///  - parameter data:                       數據, 數據的格式参照示例
    ///  - parameter defaultSeletedIndexs:       默認選中的每一列的行數
    ///  - parameter autoSetSelectedText:        設置為true的時候, 將按默認的格式自動設置textField的值
    ///  - parameter completeAction:             響應完成的Closure
    ///
    ///  - returns:
    public func showMultipleAssociatedColsPicker(_ toolBarTitle: String, data: MultipleAssociatedDataType, defaultSelectedValues: [String]?,autoSetSelectedText: Bool, completeAction: MultipleCompleteAction?) {
        self.autoSetSelectedText = autoSetSelectedText
        
        setUpPickerClosure = {() -> PickerView in
            
            return PickerView.multipleAssociatedCosPicker(toolBarTitle, multipleAssociatedColsData: data, defaultSelectedValues: defaultSelectedValues,cancelAction: { [unowned self] in
                
                self.endEditing(true)
                
            }, completeAction:{[unowned self] (selectedIndexs: [Int], selectedValues: [String]) -> Void in
                
                completeAction?(self, selectedIndexs, selectedValues)
                self.endEditing(true)
            })
        }
        
    }
    
    
    /// 城市选择器
    ///
    ///  - parameter title:                      標題
    ///  - parameter defaultSeletedValues:       默認選中的每一列的值, 注意不是行數
    ///  - parameter autoSetSelectedText:        設置為true的時候, 將按默認的格式自動設置textField的值
    ///  - parameter completeAction:             響應完成的Closure
    ///
    ///  - returns:
    
    public func showCitiesPicker(_ toolBarTitle: String, defaultSelectedValues: [String]?,autoSetSelectedText: Bool, completeAction: MultipleCompleteAction?) {
        self.autoSetSelectedText = autoSetSelectedText
        
        setUpPickerClosure = {() -> PickerView in
            
            return PickerView.citiesPicker(toolBarTitle: toolBarTitle, defaultSelectedValues: defaultSelectedValues, cancelAction: { [unowned self] in
                
                self.endEditing(true)
                
            }, completeAction:{[unowned self] (selectedIndexs: [Int], selectedValues: [String]) -> Void in
                
                completeAction?(self,selectedIndexs, selectedValues)
                self.endEditing(true)
            })
        }
        
    }
    
    /// 日期选择器
    ///
    ///  - parameter title:                      標題
    ///  - parameter datePickerSetting:          可配置UIDatePicker的樣式
    ///  - parameter autoSetSelectedText:        設置為true的時候, 將按默認的格式自動設置textField的值
    ///  - parameter completeAction:             響應完成的Closure
    ///
    ///  - returns:
    public func showDatePicker(_ toolBarTitle: String, datePickerSetting: DatePickerSetting = DatePickerSetting(), autoSetSelectedText: Bool, completeAction: DateCompleteAction?) {
        self.autoSetSelectedText = autoSetSelectedText
        
        setUpPickerClosure = {() -> PickerView in
            
            return PickerView.datePicker(toolBarTitle: toolBarTitle, datePickerSetting: datePickerSetting, cancelAction: { [unowned self] in
                
                self.endEditing(true)
                
            }, completeAction: {[unowned self]  (selectedDate) in
                
                completeAction?(self, selectedDate)
                self.endEditing(true)
            })
        }
    }
}
