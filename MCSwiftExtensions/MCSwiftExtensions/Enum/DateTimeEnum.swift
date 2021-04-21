//
//  DateTimeEnum.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation

public enum DateTimeFormat: String {
    
    /// 日期格式
    case DATE_FORMAT = "yyyy-MM-dd"
    
    /// 日期格式(斜線)
    case DATE_FORMAT_SLASH = "yyyy/MM/dd"
    
    /// 年月格式
    case YEAR_MONTH_FORMAT = "yyyy-MM"
    
    /// 年月格式(斜線)
    case YEAR_MONTH_FORMAT_SLASH = "yyyy/MM"
    
    /// 時間格式
    case TIME_FORMAT = "HH:mm"
    
    /// 日期時間格式(除秒)
    case DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm"
    
    /// 日期時間格式(除秒斜線)
    case DATE_TIME_FORMAT_SLASH = "yyyy/MM/dd HH:mm"
    
    /// 日期時間格式
    case DATE_HOUR_MIN_SEC_FORMAT = "yyyy-MM-dd HH:mm:ss"
    
    /// 日期時間格式(斜線)
    case DATE_HOUR_MIN_SEC_FORMAT_SLASH = "yyyy/MM/dd HH:mm:ss"
}
