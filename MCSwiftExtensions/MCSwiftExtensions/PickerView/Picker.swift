//
//  Picker.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/27.
//

import Foundation
import UIKit

struct AssociatedDataModel {
    var key: String
    var valueArray: [String]?
    init(key: String, valueArray: [String]? = nil) {
        self.key        = key
        self.valueArray = valueArray
    }
}

class Picker: UIView {
    
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // 使用模型初始化數據示例
    let associatedData: [[AssociatedDataModel]] = [
        
        // 第一列數據 (key)
        [   AssociatedDataModel(key: "交通工具"),
            AssociatedDataModel(key: "食品"),
            AssociatedDataModel(key: "游戏")
        ],
        
        // 第二列數據 (valueArray)
        [    AssociatedDataModel(key: "交通工具", valueArray: ["陆地", "空中", "水上"]),
             AssociatedDataModel(key: "食品", valueArray: ["健康食品", "垃圾食品"]),
             AssociatedDataModel(key: "游戏", valueArray: ["益智游戏", "角色游戏"]),
        ],
        
        // 第三列數據 (valueArray)
        [   AssociatedDataModel(key: "陆地", valueArray: ["公交车", "小轿车", "自行车"]),
            AssociatedDataModel(key: "空中", valueArray: ["飞机"]),
            AssociatedDataModel(key: "水上", valueArray: ["轮船"]),
            AssociatedDataModel(key: "健康食品", valueArray: ["蔬菜", "水果"]),
            AssociatedDataModel(key: "垃圾食品", valueArray: ["辣条", "不健康小吃"]),
            AssociatedDataModel(key: "益智游戏", valueArray: ["消消乐", "消灭星星"]),
            AssociatedDataModel(key: "角色游戏", valueArray: ["lol", "cf"])
        ]
    ]
    
    enum PickerStyles: Int {
        case Single = 0
        case Multiple
        case MultipleAssociated
    }
    
    var pickerStyle: PickerStyles = .Single
    
    // 完成按鈕的響應Closure
    typealias ButtonAction = () -> ()
    typealias SingleCompleteAction = (_ selectedIndex: Int, _ selectedValue: String) -> ()
    typealias MultipleCompleteAction = (_ selectedIndexs: [Int], _ selectedValues: [String]) -> ()
    
    fileprivate var cancelAction: ButtonAction? {
        didSet {
            tool.cancelAction = cancelAction
        }
    }
    
    // MARK: - 只有一列的時候用到的屬性
    fileprivate var singleCompleteOnClick: SingleCompleteAction? {
        didSet {
            tool.completeAction = {[unowned self] in
                self.singleCompleteOnClick?(self.selectedIndex, self.selectedValue)
            }
        }
    }
    
    fileprivate var defaultSelectedIndex: Int? {
        
        didSet {
            
            if let defaultIndex = defaultSelectedIndex, let singleData = singleColData {
                
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
    
    fileprivate var singleColData: [String]?
    fileprivate var selectedIndex: Int = 0
    fileprivate var selectedValue: String = ""
    
    // MARK: - 多列不關聯的時候用到的屬性
    var multipleCompleteOnClick: MultipleCompleteAction? {
        
        didSet {
            
            tool.completeAction = {[unowned self] in
                
                self.multipleCompleteOnClick?(self.selectedIndexs, self.selectedValues)
            }
        }
    }
    
    fileprivate var multipleColsData: [[String]]? {
        
        didSet {
            
            if let multipleData = multipleColsData {
                for _ in multipleData.indices {
                    selectedIndexs.append(0)
                    selectedValues.append(" ")
                }
            }
        }
    }
    
    fileprivate var defalultSelectedIndexs: [Int]? {
        
        didSet {
            
            if let defaultIndexs = defalultSelectedIndexs {
                
                defaultIndexs.enumerated().forEach({ (component, row) in
                    
                    assert(component < pickerView.numberOfComponents && row < pickerView.numberOfRows(inComponent: component), "設置的默認選中Indexs有不合法的")
                    
                    if component < pickerView.numberOfComponents && row < pickerView.numberOfRows(inComponent: component) {
                        
                        // 滾動到默認位置
                        pickerView.selectRow(row, inComponent: component, animated: false)
                        
                        // 設置默認值
                        selectedIndexs[component] = row
                        selectedValues[component] = self.pickerView(pickerView, titleForRow: row, forComponent: component) ?? " "
                    }
                })
                
            } else {
                
                multipleColsData?.indices.forEach({ (index) in
                    
                    // 滾動到默認位置
                    pickerView.selectRow(0, inComponent: index, animated: false)
                    
                    // 設置默認選中值
                    selectedIndexs[index] = 0
                    selectedValues[index] = self.pickerView(pickerView, titleForRow: 0, forComponent: index) ?? " "
                })
            }
        }
    }
    
    fileprivate var selectedIndexs: [Int] = []
    fileprivate var selectedValues: [String] = []
    
    // MARK: - 多列關聯的時候用到的屬性
    fileprivate var multipleAssociatedColsData: [[AssociatedDataModel]]? {
        
        didSet {
            
            if let multipleAssociatedData = multipleAssociatedColsData {
                
                // 初始化選中的values
                for _ in multipleAssociatedData.indices {
                    selectedIndexs.append(0)
                    selectedValues.append(" ")
                }
            }
        }
    }
    
    // 設置第一組的數據, 使用數組是因為字典無序,需要設置默認選中值的時候獲取到準確的下標滾動到相應的行
    fileprivate var defaultSelectedValues: [String]? {
        
        didSet {
            
            if let defaultValues = defaultSelectedValues {
                
                // 設置默認值
                selectedValues = defaultValues
                
                defaultValues.enumerated().forEach { (component: Int, element: String) in
                    
                    var row: Int? = nil
                    
                    if component == 0 {
                        
                        let firstData = multipleAssociatedColsData![0]
                        
                        for (index, associatedModel) in firstData.enumerated() {
                            if associatedModel.key == element {
                                row = index
                            }
                        }
                        
                    } else {
                        
                        let associatedModels = multipleAssociatedColsData![component]
                        var arr: [String]?
                        
                        for associatedModel in associatedModels {
                            if associatedModel.key == selectedValues[component - 1] {
                                arr = associatedModel.valueArray
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
                        // 滾動到默認的位置
                        pickerView.selectRow(row!, inComponent: component, animated: false)
                        // 設置選中的下標
                        selectedIndexs[component] = row!
                    }
                }
                
            } else {
                
                multipleAssociatedColsData?.indices.forEach({ (index) in
                    // 滾動到默認的位置 0 行
                    pickerView.selectRow(0, inComponent: index, animated: false)
                    // 設置默認的選中值
                    selectedValues[index] = self.pickerView(pickerView, titleForRow: 0, forComponent: index) ?? " "
                    selectedIndexs[index] = 0
                })
            }
        }
    }
    
    // 公用屬性
    private lazy var pickerView: UIPickerView = { [unowned self] in
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        return picker
    }()
    
    private lazy var tool: ToolBarView = ToolBarView()
    
    private let pickerViewHeight: CGFloat = 216.0
    private let toolBarHeight: CGFloat = 44.0
    
    let screenW = UIScreen.main.bounds.size.width
    
    init() {
        let frame = CGRect(x: 0.0,
                           y: 0.0,
                           width: screenW,
                           height: toolBarHeight + pickerViewHeight)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.debugDescription) --- 銷毀")
    }
    
    func commonInit() {
        addSubview(tool)
        addSubview(pickerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tool.frame = CGRect(x: 0.0,
                            y: 0.0,
                            width: screenWidth,
                            height: toolBarHeight)
        pickerView.frame = CGRect(x: 0.0,
                                  y: 44.0,
                                  width: screenW,
                                  height: pickerViewHeight)
    }
}


extension Picker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch pickerStyle {
        
        case .Single:
            return singleColData == nil ? 0 : 1
            
        case .Multiple:
            return multipleColsData?.count ?? 0
            
        case .MultipleAssociated:
            return multipleAssociatedColsData?.count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerStyle {
        
        case .Single:
            return singleColData?.count ?? 0
            
        case .Multiple:
            return multipleColsData?[component].count ?? 0
            
        case .MultipleAssociated:
            
            if let multipleAssociatedData = multipleAssociatedColsData {
                
                if component == 0 {
                    
                    return multipleAssociatedData[0].count
                    
                } else {
                    
                    let associatedDataModels = multipleAssociatedData[component]
                    var arr: [String]?
                    
                    for associatedDataModel in associatedDataModels {
                        if associatedDataModel.key == selectedValues[component - 1] {
                            arr = associatedDataModel.valueArray
                        }
                    }
                    
                    return arr?.count ?? 0
                }
            }
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerStyle {
        
        case .Single:
            
            selectedIndex = row
            selectedValue = singleColData![row]
            return
            
        case .Multiple:
            
            selectedIndexs[component] = row
            selectedValues[component] = self.pickerView(pickerView, titleForRow: row, forComponent: component) ?? " "
            return
            
        case .MultipleAssociated:
            
            // 設置選中值
            selectedValues[component] = self.pickerView(pickerView, titleForRow: row, forComponent: component) ?? " "
            selectedIndexs[component] = row
            
            // 更新下一列關聯的值
            if component < multipleAssociatedColsData!.count - 1 {
                pickerView.reloadComponent(component + 1)
                // 遞迴
                self.pickerView(pickerView, didSelectRow: 0, inComponent: component+1)
                pickerView.selectRow(0, inComponent: component+1, animated: true)
                
            }
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerStyle {
        
        case .Single:
            return singleColData?[row]
            
        case .Multiple:
            return multipleColsData?[component][row]
            
        case .MultipleAssociated:
            
            if let multipleAssociatedData = multipleAssociatedColsData {
                
                if component == 0 {
                    
                    return multipleAssociatedData[0][row].key
                    
                }else {
                    
                    let associatedDataModels = multipleAssociatedData[component]
                    var arr: [String]?
                    
                    for associatedDataModel in associatedDataModels {
                        if associatedDataModel.key == selectedValues[component - 1] {
                            arr = associatedDataModel.valueArray
                        }
                    }
                    
                    if arr?.count == 0 {
                        // 空數組
                        return nil
                    }
                    
                    return arr?[row]
                }
            }
            
            return nil
        }
        
    }
    
}


// MARK: - 快速使用方法
extension Picker {
    
    /// 單列
    class func singleColPicker(singleColData: [String], defaultIndex: Int?, cancelAction: ButtonAction?, completeAction: SingleCompleteAction?) -> Picker {
        
        let  pic = Picker()
        pic.pickerStyle = .Single
        pic.singleColData = singleColData
        pic.defaultSelectedIndex = defaultIndex
        pic.singleCompleteOnClick = completeAction
        pic.cancelAction = cancelAction
        
        return pic
    }
    
    /// 多列不關聯
    class func multipleCosPicker(multipleColsData: [[String]], defaultSelectedIndexs: [Int]?,cancelAction: ButtonAction?, completeAction: MultipleCompleteAction?) -> Picker {
        
        let pic = Picker()
        pic.pickerStyle = .Multiple
        pic.multipleColsData = multipleColsData
        pic.defalultSelectedIndexs = defaultSelectedIndexs
        pic.cancelAction = cancelAction
        pic.multipleCompleteOnClick = completeAction
        
        return pic
    }
    
    /// 多列關聯
    class func multipleAssociatedCosPicker(multipleAssociatedColsData: [[AssociatedDataModel]], defaultSelectedValues: [String]?, cancelAction: ButtonAction?, completeAction: MultipleCompleteAction?) -> Picker {
        
        let pic = Picker()
        pic.pickerStyle = .MultipleAssociated
        pic.multipleAssociatedColsData = multipleAssociatedColsData
        pic.defaultSelectedValues = defaultSelectedValues
        pic.cancelAction = cancelAction
        pic.multipleCompleteOnClick = completeAction
        
        return pic
    }
    
    /// 城市選擇器
    class func citiesPicker(defaultSelectedValues: [String]?, cancelAction: ButtonAction?, completeAction: MultipleCompleteAction?) -> Picker {
        
        let provincePath = Bundle.main.path(forResource: "Province", ofType: "plist")
        let cityPath = Bundle.main.path(forResource: "City", ofType: "plist")
        
        let proviceArr = NSArray(contentsOfFile: provincePath!)
        let cityArr = NSDictionary(contentsOfFile: cityPath!)
        
        var provinceModelArr: [AssociatedDataModel] = []
        var citiesModelArr: [AssociatedDataModel] = []
        
        proviceArr?.forEach({ (element) in
            if let province = element as? String {
                provinceModelArr.append(AssociatedDataModel(key: province))
                
                let citys = cityArr?[province] as? [String]
                citiesModelArr.append(AssociatedDataModel(key: province, valueArray: citys))
            }
        })
        
        let citiesArr = [provinceModelArr, citiesModelArr]
        
        let pic = Picker.multipleAssociatedCosPicker(multipleAssociatedColsData: citiesArr, defaultSelectedValues: defaultSelectedValues, cancelAction: cancelAction, completeAction: completeAction)
        
        return pic
    }
}
