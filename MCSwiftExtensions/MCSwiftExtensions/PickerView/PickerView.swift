//
//  PickerView.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/27.
//

import Foundation
import UIKit

// MARK: - PickerViewDelegate 用於自動設置TextField的選中值
public protocol PickerViewDelegate: class {
    func singleColDidSelected(_ selectedIndex: Int, selectedValue: String)
    func multipleColsDidSelected(_ selectedIndexs: [Int], selectedValues: [String])
    func dateDidSelected(_ selectedDate: Date)
}

// MARK: - 配置UIDatePicker的樣式
public struct DatePickerSetting {
    
    /// 默認選中時間
    public var date = Date()
    public var dateMode = UIDatePicker.Mode.date
    
    // 最小時間
    public var minimumDate: Date?
    
    // 最大時間
    public var maximumDate: Date?
    
    // 時間間隔
    public var minuteInterval: Int = 1
    
    // 地區
    public var locale: Locale = Locale(identifier: "zh_TW")
    
    public init() {
        
    }
}

// MARK: - PickerView
open class PickerView: UIView {
    
    public enum PickerStyles {
        case single
        case multiple
        case multipleAssociated
        case date
    }
    
    fileprivate let screenWidth = UIScreen.main.bounds.size.width
    fileprivate let pickerViewHeight: CGFloat = 216.0
    fileprivate let toolBarHeight: CGFloat = 44.0
    
    open weak var delegate: PickerViewDelegate?
    
    fileprivate var toolBarTitle = "請選擇" {
        didSet {
            toolBar.title = toolBarTitle
        }
    }
    
    fileprivate var toolBarTextColor = UIColor.black {
        didSet {
            toolBar.toolBarTextColor = toolBarTextColor
        }
    }
    
    fileprivate var toolBarBackgroundColor = UIColor.white {
        didSet {
            toolBar.toolBarBackgroundColor = toolBarBackgroundColor
        }
    }
    
    fileprivate var okTitle = "confirm".localized() {
        didSet {
            toolBar.okTitle = okTitle
        }
    }
    
    fileprivate var cancelTitle = "cancel".localized() {
        didSet {
            toolBar.cancelTitle = cancelTitle
        }
    }
    
    fileprivate var pickerStyle: PickerStyles = .single
    
    // 配置UIDatePicker的樣式
    fileprivate var datePickerSetting = DatePickerSetting() {
        
        didSet {
            
            datePicker.date = datePickerSetting.date
            datePicker.locale = datePickerSetting.locale
            datePicker.minimumDate = datePickerSetting.minimumDate
            datePicker.maximumDate = datePickerSetting.maximumDate
            datePicker.datePickerMode = datePickerSetting.dateMode
            datePicker.minuteInterval = datePickerSetting.minuteInterval
            
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.backgroundColor = .white
            }
            
            /// set currentDate to the default
            selectedDate = datePickerSetting.date
        }
    }
    
    // 完成按鈕的響應Closure
    public typealias ButtonAction = () -> Void
    public typealias SingleCompleteAction = (_ selectedIndex: Int, _ selectedValue: String) -> Void
    public typealias MultipleCompleteAction = (_ selectedIndexs: [Int], _ selectedValues: [String]) -> Void
    public typealias DateCompleteAction = (_ selectedDate: Date) -> Void
    public typealias MultipleAssociatedDataType = [[[String: [String]?]]]
    
    fileprivate var cancelAction: ButtonAction? {
        
        didSet {
            
            toolBar.cancelAction = cancelAction
        }
    }
    
    //MARK:- 只有一列的時候用到的屬性
    fileprivate var singleCompleteOnClick:SingleCompleteAction? = nil {
        
        didSet {
            
            toolBar.completeAction =  {[unowned self] in
                
                self.singleCompleteOnClick?(self.selectedIndex, self.selectedValue)
            }
        }
    }
    
    fileprivate var defalultSelectedIndex: Int? = nil {
        
        didSet {
            
            if let defaultIndex = defalultSelectedIndex, let singleData = singleColData {
                // 判斷下標是否合法
                assert(defaultIndex >= 0 && defaultIndex < singleData.count, "設置的默認選中Index不合法")
                if defaultIndex >= 0 && defaultIndex < singleData.count {
                    // 設置默認值
                    selectedIndex = defaultIndex
                    selectedValue = singleData[defaultIndex]
                    // 滾動到默認位置
                    pickerView.selectRow(defaultIndex, inComponent: 0, animated: false)
                    
                }
                
            } else {
                
                // 沒有默認值設置0行為默認值
                selectedIndex = 0
                selectedValue = singleColData![0]
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
        }
    }
    
    fileprivate var singleColData: [String]? = nil
    fileprivate var selectedIndex: Int = 0
    fileprivate var selectedValue: String = "" {
        didSet {
            delegate?.singleColDidSelected(selectedIndex, selectedValue: selectedValue)
        }
    }
    
    //MARK:- 有多列不關聯的時候用到的屬性
    fileprivate var multipleCompleteOnClick:MultipleCompleteAction? = nil {
        
        didSet {
            
            toolBar.completeAction =  {[unowned self] in
                self.multipleCompleteOnClick?(self.selectedIndexs, self.selectedValues)
            }
        }
    }
    
    fileprivate var multipleColsData: [[String]]? = nil {
        
        didSet {
            
            if let multipleData = multipleColsData {
                for _ in multipleData.indices {
                    selectedIndexs.append(0)
                    selectedValues.append(" ")
                }
                
            }
        }
    }
    
    fileprivate var selectedIndexs: [Int] = []
    fileprivate var selectedValues: [String] = [] {
        didSet {
            delegate?.multipleColsDidSelected(selectedIndexs, selectedValues: selectedValues)
        }
    }
    
    // 不關聯的數據時直接設置默認的下標
    fileprivate var defalultSelectedIndexs: [Int]? = nil {
        
        didSet {
            
            if let defaultIndexs = defalultSelectedIndexs {
                
                defaultIndexs.enumerated().forEach({ (component: Int, row: Int) in
                    
                    assert(component < pickerView.numberOfComponents && row < pickerView.numberOfRows(inComponent: component), "設置的默認選中Indexs中有不合法的")
                    if component < pickerView.numberOfComponents && row < pickerView.numberOfRows(inComponent: component){
                        
                        // 滾動到默認位置
                        
                        // 設置默認值
                        selectedIndexs[component] = row
                        selectedValues[component] = titleForRow(row, forComponent: component) ?? " "
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.pickerView.selectRow(row, inComponent: component, animated: false)
                        })
                        
                    }
                    
                })
                
            } else {
                multipleColsData?.indices.forEach({ (index) in
                    // 滾動到默認位置
                    pickerView.selectRow(0, inComponent: index, animated: false)
                    
                    // 設置默認選中值
                    selectedIndexs[index] = 0
                    
                    selectedValues[index] = titleForRow(0, forComponent: index) ?? " "
                    
                })
            }
        }
    }
    
    //MARK: - 有多列关联的时候用到的属性
    fileprivate var multipleAssociatedColsData: MultipleAssociatedDataType? = nil {
        
        didSet {
            
            if let multipleAssociatedData = multipleAssociatedColsData {
                // 初始化選中的values
                for _ in 0...multipleAssociatedData.count {
                    selectedIndexs.append(0)
                    selectedValues.append(" ")
                }
            }
        }
    }
    
    // 多列關聯數據的時候設置默認的values而沒有使用默認的index
    fileprivate var defaultSelectedValues: [String]? = nil {
        
        didSet {
            
            if let defaultValues = defaultSelectedValues {
                // this is a wrong way cause defaultValues is less than components' count
                //                selectedValues = defaultValues
                defaultValues.enumerated().forEach { (component: Int, element: String) in
                    var row: Int? = nil
                    
                    if component == 0 {
                        let firstData = multipleAssociatedColsData![0]
                        
                        for (index,associatedModel) in firstData.enumerated() {
                            if associatedModel.first!.0 == element {
                                row = index
                                break
                            }
                        }
                    } else {
                        
                        let associatedModels = multipleAssociatedColsData![component - 1]
                        var arr: [String]?
                        
                        for associatedModel in associatedModels {
                            
                            if associatedModel.first!.0 == defaultValues[component - 1] {
                                arr = associatedModel.first!.1
                                break
                            }
                        }
                        row = arr?.firstIndex(of: element)
                        
                    }
                    
                    assert(row != nil, "第\(component)列設置的默認值有誤")
                    if row == nil {
                        row = 0
                        print("第\(component)列設置的默認值有誤")
                    }
                    if component < pickerView.numberOfComponents {
                        //                        print(" \(component) ----\(row!)")
                        
                        // 設置選中的下標
                        selectedIndexs[component] = row!
                        // 設置默認值
                        selectedValues[component] = titleForRow(row!, forComponent: component) ?? " "
                        // 滾動到默認的位置
                        DispatchQueue.main.async(execute: {
                            
                            self.pickerView.selectRow(row!, inComponent: component, animated: false)
                        })
                        
                    }
                    
                }
                
            } else {
                
                for index in 0...multipleAssociatedColsData!.count {
                    // 滾動到默認的位置 0 行
                    pickerView.selectRow(0, inComponent: index, animated: false)
                    // 設置默認的選中值
                    selectedValues[index] = titleForRow(0, forComponent: index) ?? " "
                    
                    selectedIndexs[index] = 0
                }
            }
        }
    }
    
    // MARK: - 日期選擇器用到的屬性
    fileprivate var selectedDate = Date() {
        didSet {
            delegate?.dateDidSelected(selectedDate)
        }
    }
    
    fileprivate var dateCompleteAction: DateCompleteAction? {
        didSet {
            toolBar.completeAction = {[unowned self] in
                self.dateCompleteAction?(self.selectedDate)
            }
        }
    }
    
    fileprivate lazy var pickerView: UIPickerView! = { [unowned self] in
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        if #available(iOS 13.0, *) {
            picker.backgroundColor = .systemBackground
        } else {
            picker.backgroundColor = .white
        }
        return picker
    }()
    
    fileprivate lazy var datePicker: UIDatePicker = {[unowned self] in
        let datePic = UIDatePicker()
        if #available(iOS 13.0, *) {
            datePic.backgroundColor = .systemBackground
        } else {
            datePic.backgroundColor = .white
        }
        // print(NSLocale.availableLocaleIdentifiers())
        datePic.locale = Locale(identifier: "zh_TW")
        return datePic
    }()
    
    fileprivate lazy var toolBar: ToolBarView! = ToolBarView()
    
    // MARK: - 初始化
    public init(pickerStyle: PickerStyles) {
        let frame = CGRect(x: 0.0,
                           y: 0.0,
                           width: screenWidth,
                           height: toolBarHeight + pickerViewHeight)
        self.pickerStyle = pickerStyle
        super.init(frame: frame)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        print("\(self.debugDescription) --- 銷毀")
    }
    
    fileprivate func commonInit() {
        
        addSubview(toolBar)
        
        if pickerStyle == PickerStyles.date {
            
            datePicker.addTarget(self,
                                 action: #selector(self.dateDidChange(_:)),
                                 for: UIControl.Event.valueChanged)
            addSubview(datePicker)
            
        } else {
            
            addSubview(pickerView)
        }
    }
    
    @objc func dateDidChange(_ datePic: UIDatePicker) {
        selectedDate = datePic.date
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let toolBarX = NSLayoutConstraint(item: toolBar!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let toolBarY = NSLayoutConstraint(item: toolBar!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let toolBarW = NSLayoutConstraint(item: toolBar!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        let toolBarH = NSLayoutConstraint(item: toolBar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(toolBarHeight))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints([toolBarX, toolBarY, toolBarW, toolBarH])
        
        if pickerStyle == PickerStyles.date {
            
            let pickerX = NSLayoutConstraint(item: datePicker, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
            
            let pickerY = NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: CGFloat(toolBarHeight))
            let pickerW = NSLayoutConstraint(item: datePicker, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
            let pickerH = NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(pickerViewHeight))
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraints([pickerX, pickerY, pickerW, pickerH])
            
        } else {
            
            let pickerX = NSLayoutConstraint(item: pickerView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
            
            let pickerY = NSLayoutConstraint(item: pickerView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: CGFloat(toolBarHeight))
            let pickerW = NSLayoutConstraint(item: pickerView!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
            let pickerH = NSLayoutConstraint(item: pickerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(pickerViewHeight))
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraints([pickerX, pickerY, pickerW, pickerH])
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    final public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch pickerStyle {
        
        case .single:
            return singleColData == nil ? 0 : 1
            
        case .multiple:
            return multipleColsData?.count ?? 0
            
        case .multipleAssociated:
            return multipleAssociatedColsData == nil ? 0 : multipleAssociatedColsData!.count + 1
            
        default:
            return 0
        }
    }
    
    final public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerStyle {
        
        case .single:
            return singleColData?.count ?? 0
            
        case .multiple:
            return multipleColsData?[component].count ?? 0
            
        case .multipleAssociated:
            
            if let multipleAssociatedData = multipleAssociatedColsData {
                
                if component == 0 {
                    return multipleAssociatedData[0].count
                }else {
                    let associatedDataModels = multipleAssociatedData[component - 1]
                    var arr: [String]?
                    
                    for associatedDataModel in associatedDataModels {
                        if associatedDataModel.first!.0 == selectedValues[component - 1] {
                            arr = associatedDataModel.first!.1
                        }
                    }
                    
                    return arr?.count ?? 0
                    
                }
                
            }
            return 0
            
        default:
            return 0
        }
    }
    
    final public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerStyle {
        
        case .single:
            
            selectedIndex = row
            selectedValue = singleColData![row]
            
            return
            
        case .multiple:
            
            selectedIndexs[component] = row
            
            if let title = titleForRow(row, forComponent: component) {
                selectedValues[component] = title
            }
            
            return
            
        case .multipleAssociated:
            
            // 設置選中值
            if let title = titleForRow(row, forComponent: component) {
                selectedValues[component] = title
                selectedIndexs[component] = row
                // 更新下一列關聯的值
                if component < multipleAssociatedColsData!.count {
                    pickerView.reloadComponent(component + 1)
                    // 遞迴
                    self.pickerView(pickerView, didSelectRow: 0, inComponent: component+1)
                    pickerView.selectRow(0, inComponent: component+1, animated: true)
                    
                }
            }
            
            return
            
        default:
            return
        }
    }
    
    final public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        //文字顏色
        if traitCollection.userInterfaceStyle == .dark {
            
            label.textColor = .white
            
        }else{
            
            label.textColor = .black
        }
        
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.backgroundColor = .clear
        label.text = titleForRow(row, forComponent: component)
        
        return label
    }
    
    // Helper
    fileprivate func titleForRow(_ row: Int, forComponent component: Int) -> String? {
        
        switch pickerStyle {
        
        case .single:
            return singleColData?[row]
            
        case .multiple:
            return multipleColsData?[component][row]
            
        case .multipleAssociated:
            
            if let multipleAssociatedData = multipleAssociatedColsData {
                
                if component == 0 {
                    return multipleAssociatedData[0][row].first!.0
                }else {
                    let associatedDataModels = multipleAssociatedData[component - 1]
                    var arr: [String]?
                    
                    for associatedDataModel in associatedDataModels {
                        if associatedDataModel.first!.0 == selectedValues[component - 1] {
                            arr = associatedDataModel.first!.1
                        }
                    }
                    if arr?.count == 0 {// 空數組
                        return nil
                    }
                    return arr?[row]
                    
                }
                
            }
            return nil
            
        default:
            return nil
        }
    }
}

extension PickerView {
    
    /// 單列選擇
    /// - Parameters:
    ///   - toolBarTitle:           工具列標題
    ///   - toolBarTextColor:       工具列標題文字顏色
    ///   - toolBarBackgroundColor: 工具列背景色
    ///   - okTitle:                確定按鈕文字
    ///   - cancelTitle:            取消按鈕文字
    ///   - singleColData:          數據
    ///   - defaultIndex:           預設選中Index
    ///   - cancelAction:           取消按鈕 Closure
    ///   - completeAction:         確定按鈕 Closure
    /// - Returns: SingleColPicker
    public class func singleColPicker(toolBarTitle: String,
                                      toolBarTextColor: UIColor? = UIColor.black,
                                      toolBarBackgroundColor: UIColor? = UIColor.white,
                                      okTitle: String = "confirm".localized(),
                                      cancelTitle: String = "cancel".localized(),
                                      singleColData: [String],
                                      defaultIndex: Int?,
                                      cancelAction: ButtonAction?,
                                      completeAction: SingleCompleteAction?) -> PickerView {
        
        let pic = PickerView(pickerStyle: .single)
        
        pic.toolBarTitle = toolBarTitle
        pic.toolBarTextColor = toolBarTextColor!
        pic.toolBarBackgroundColor = toolBarBackgroundColor!
        
        pic.okTitle = okTitle
        pic.cancelTitle = cancelTitle
        
        pic.singleColData = singleColData
        pic.defalultSelectedIndex = defaultIndex
        
        pic.cancelAction = cancelAction
        pic.singleCompleteOnClick = completeAction
        
        return pic
    }
    
    /// 多列不關聯選擇
    /// - Parameters:
    ///   - toolBarTitle:           工具列標題
    ///   - toolBarTextColor:       工具列標題文字顏色
    ///   - toolBarBackgroundColor: 工具列背景色
    ///   - okTitle:                確定按鈕文字
    ///   - cancelTitle:            取消按鈕文字
    ///   - multipleColsData:       數據
    ///   - defaultIndexes:         預設選中Indexes
    ///   - cancelAction:           取消按鈕 Closure
    ///   - completeAction:         確定按鈕 Closure
    /// - Returns: MultipleColsPicker
    public class func multipleColsPicker(toolBarTitle: String,
                                         toolBarTextColor: UIColor? = UIColor.black,
                                         toolBarBackgroundColor: UIColor? = UIColor.white,
                                         okTitle: String = "confirm".localized(),
                                         cancelTitle: String = "cancel".localized(),
                                         multipleColsData: [[String]],
                                         defaultIndexes: [Int]?,
                                         cancelAction: ButtonAction?,
                                         completeAction: MultipleCompleteAction?) -> PickerView {
        
        let pic = PickerView(pickerStyle: .multiple)
        
        pic.toolBarTitle = toolBarTitle
        pic.toolBarTextColor = toolBarTextColor!
        pic.toolBarBackgroundColor = toolBarBackgroundColor!
        
        pic.okTitle = okTitle
        pic.cancelTitle = cancelTitle
        
        pic.multipleColsData = multipleColsData
        pic.defalultSelectedIndexs = defaultIndexes
        
        pic.cancelAction = cancelAction
        pic.multipleCompleteOnClick = completeAction
        
        return pic
    }
    
    /// 多列關聯
    public class func multipleAssociatedCosPicker(_ toolBarTitle: String,
                                                  multipleAssociatedColsData: MultipleAssociatedDataType,
                                                  defaultSelectedValues: [String]?,
                                                  cancelAction: ButtonAction?,
                                                  completeAction: MultipleCompleteAction?) -> PickerView {
        
        let pic = PickerView(pickerStyle: .multipleAssociated)
        pic.toolBarTitle = toolBarTitle
        pic.multipleAssociatedColsData = multipleAssociatedColsData
        pic.defaultSelectedValues = defaultSelectedValues
        pic.cancelAction = cancelAction
        pic.multipleCompleteOnClick = completeAction
        
        return pic
    }
    
    /// 城市選擇器
    public class func citiesPicker(toolBarTitle: String,
                                   toolBarTextColor: UIColor? = UIColor.black,
                                   toolBarBackgroundColor: UIColor? = UIColor.white,
                                   defaultSelectedValues: [String]?,
                                   selectTopLevel:Bool = false,
                                   cancelAction: ButtonAction?,
                                   completeAction: MultipleCompleteAction?) -> PickerView {
        
        let provincePath = Bundle.main.path(forResource: "Province", ofType: "plist")
        let cityPath = Bundle.main.path(forResource: "City", ofType: "plist")
        // 這裡需要使用數組, 因為字典無序, 如果只使用 cityArr,areaArr, 那麼顯示將是無序的, 不能按照plist中的數組顯示
        let proviceArr = NSArray(contentsOfFile: provincePath!)
        let cityArr = NSDictionary(contentsOfFile: cityPath!)
        
        var citiesModelArr: [[String: [String]?]] = []
        
        proviceArr?.forEach({ (element) in
            if let provinceStr = element as? String {
                
                let cities = cityArr?[provinceStr] as? [String]
                citiesModelArr.append([provinceStr: cities])
            }
        })
        
        let citiesArr = [citiesModelArr]
        
        let pic = PickerView.multipleAssociatedCosPicker(toolBarTitle,
                                                         multipleAssociatedColsData: citiesArr,
                                                         defaultSelectedValues: defaultSelectedValues,
                                                         cancelAction: cancelAction,
                                                         completeAction: completeAction)
        pic.toolBarTextColor = toolBarTextColor!
        pic.toolBarBackgroundColor = toolBarBackgroundColor!
        
        return pic
    }
    
    /// 時間選擇器
    /// - Parameters:
    ///   - toolBarTitle:           工具列標題
    ///   - toolBarTextColor:       工具列標題文字顏色
    ///   - toolBarBackgroundColor: 工具列背景色
    ///   - okTitle:                確定按鈕文字
    ///   - cancelTitle:            取消按鈕文字
    ///   - datePickerSetting:      datePickerSetting
    ///   - cancelAction:           取消按鈕 Closure
    ///   - completeAction:         確定按鈕 Closure
    /// - Returns: DatePicker
    public class func datePicker(toolBarTitle: String,
                                 toolBarTextColor: UIColor? = UIColor.black,
                                 toolBarBackgroundColor: UIColor? = UIColor.white,
                                 okTitle: String = "confirm".localized(),
                                 cancelTitle: String = "cancel".localized(),
                                 datePickerSetting: DatePickerSetting,
                                 cancelAction: ButtonAction?,
                                 completeAction: DateCompleteAction?) -> PickerView {
        
        let pic = PickerView(pickerStyle: .date)
        
        pic.datePickerSetting = datePickerSetting
        
        pic.toolBarTitle = toolBarTitle
        pic.toolBarTextColor = toolBarTextColor!
        pic.toolBarBackgroundColor = toolBarBackgroundColor!
        
        pic.okTitle = okTitle
        pic.cancelTitle = cancelTitle
        
        pic.cancelAction = cancelAction
        pic.dateCompleteAction = completeAction
        
        return pic
    }
}
