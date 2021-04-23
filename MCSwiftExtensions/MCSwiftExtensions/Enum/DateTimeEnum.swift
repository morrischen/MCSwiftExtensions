//
//  DateTimeEnum.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation

/// 日期時間格式列舉
public enum DateTimeFormat: String {
    
    /// 日期格式
    case Date = "yyyy-MM-dd"
    
    /// 日期格式(斜線)
    case DateSlash = "yyyy/MM/dd"
    
    /// 年月格式
    case YearMonth = "yyyy-MM"
    
    /// 年月格式(斜線)
    case YearMonthSlash = "yyyy/MM"
    
    /// 時間格式
    case Time = "HH:mm"
    
    /// 日期時間格式(去除秒數)
    case DateTime = "yyyy-MM-dd HH:mm"
    
    /// 日期時間格式(去除秒數斜線)
    case DateTimeSlash = "yyyy/MM/dd HH:mm"
    
    /// 日期時間格式
    case DateTimes = "yyyy-MM-dd HH:mm:ss"
    
    /// 日期時間格式(斜線)
    case DateTimesSlash = "yyyy/MM/dd HH:mm:ss"
}
