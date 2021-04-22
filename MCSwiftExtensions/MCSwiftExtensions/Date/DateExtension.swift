//
//  DateExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation

extension Date {
    
    /// Ref: https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/SwifterSwift/Foundation/DateExtensions.swift
    
    //MARK: - Parameters
    
    /// calendar current
    public var calendar: Calendar {
        
        // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
        return Calendar(identifier: Calendar.current.identifier)
    }
    
    /// 取得當年 / 設定年份
    ///
    ///     Date().year -> 2017
    ///
    ///     var someDate = Date()
    ///     someDate.year = 2000 // sets someDate's year to 2000
    ///
    public var year: Int {
        
        get {
            return calendar.component(.year, from: self)
        }
        
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 取得當月 / 設定月份
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    public var month: Int {
        
        get {
            return calendar.component(.month, from: self)
        }
        
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 取得當天 / 設定天數
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    public var day: Int {
        
        get {
            return calendar.component(.day, from: self)
        }
        
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 取得小時 / 設定小時
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    public var hour: Int {
        
        get {
            return calendar.component(.hour, from: self)
        }
        
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 取得分鐘 / 設定分鐘
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    public var minute: Int {
        
        get {
            return calendar.component(.minute, from: self)
        }
        
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 取得秒數 / 設定秒數
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    public var second: Int {
        
        get {
            return calendar.component(.second, from: self)
        }
        
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
  
    /// 取得毫秒數 / 設定毫秒數
    ///
    ///     Date().millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.millisecond = 68 // sets someDate's nanosecond to 68000000.
    ///
    public var millisecond: Int {
        
        get {
            return calendar.component(.nanosecond, from: self) / 1_000_000
        }
        
        set {
            let nanoSeconds = newValue * 1_000_000
            #if targetEnvironment(macCatalyst)
            // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
            let allowedRange = 0..<1_000_000_000
            #else
            let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(nanoSeconds) else { return }
            
            if let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: self) {
                self = date
            }
        }
    }
    
    /// 取得5分鐘為單位的時間
    ///
    ///     var date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes // "5:45 PM"
    ///
    public var nearestFiveMinutes: Date {
        
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self)
        
        let min = components.minute!
        
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        
        return calendar.date(from: components)!
    }

    /// 取得10分鐘為單位的時間
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    ///
    public var nearestTenMinutes: Date {
        
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self)
        
        let min = components.minute!
        
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        
        return calendar.date(from: components)!
    }

    /// 取得15分鐘為單位的時間
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    ///
    public var nearestQuarterHour: Date {
        
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self)
        
        let min = components.minute!
        
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        
        return calendar.date(from: components)!
    }

    /// 取得30分鐘為單位的時間
    ///
    ///     var date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    ///
    public var nearestHalfHour: Date {
        
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self)
        
        let min = components.minute!
        
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        
        return calendar.date(from: components)!
    }

    /// 取得一小時為單位的時間
    ///
    ///     var date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    ///
    public var nearestHour: Date {
        
        let min = calendar.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: self))!

        if min < 30 {
            return date
        }
        
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// 當週第幾天
    ///
    ///     Date().weekday -> 5 // 當週第五天
    ///
    public var weekday: Int {
        return calendar.component(.weekday, from: self)
    }
    
    /// 月份第幾週
    ///
    ///     Date().weekOfMonth -> 3 // 當月第二週
    ///
    public var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }
    
    /// 年度第幾週
    ///
    ///     Date().weekOfYear -> 2 // 今年第二週
    ///
    public var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }

    /// 是否在未來時間
    ///
    ///     Date(timeInterval: 100, since: Date()).isInFuture -> true
    ///
    public var isInFuture: Bool {
        return self > Date()
    }
    
    /// 是否為過去時間
    ///
    ///     Date(timeInterval: -100, since: Date()).isInPast -> true
    ///
    public var isInPast: Bool {
        return self < Date()
    }
    
    /// 是否為今天
    ///
    ///     Date().isInToday -> true
    ///
    public var isInToday: Bool {
        return calendar.isDateInToday(self)
    }
    
    /// 是否為昨天
    ///
    ///     Date().isInYesterday -> false
    ///
    public var isInYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }
    
    /// 是否為明天
    ///
    ///     Date().isInTomorrow -> false
    ///
    public var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    /// 是否為假日
    public var isInWeekend: Bool {
        return calendar.isDateInWeekend(self)
    }
    
    /// 是否為工作日
    public var isWorkday: Bool {
        return !calendar.isDateInWeekend(self)
    }
    
    /// 與現在時間是否為同週
    public var isInCurrentWeek: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// 與現在時間是否為同月
    public var isInCurrentMonth: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// 與現在時間是否為同年
    public var isInCurrentYear: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    //MARK: - Function
    
    /// SwifterSwift: Date by adding multiples of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    public func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }
    
    /// SwifterSwift: Add calendar component to date.
    ///
    ///     var date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     date.add(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     date.add(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     date.add(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     date.add(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenet to add.
    public mutating func add(_ component: Calendar.Component, value: Int) {
        if let date = calendar.date(byAdding: component, value: value, to: self) {
            self = date
        }
    }
    
    /// 取得日期字串
    /// - Parameter format: 轉換格式
    /// - Returns: Date String
    public func dateString(format: DateTimeFormat = .Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: self)
    }

    /// 取得日期時間字串
    /// - Parameter format: 轉換格式
    /// - Returns: Date String
    public func dateTimeString(format: DateTimeFormat = .DateTime) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: self)
    }

    /// 取得時間字串
    /// - Parameter format: 轉換格式
    /// - Returns: Date String
    public func timeString(format: DateTimeFormat = .Time) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: self)
    }
    
    /// 昨天
    public func yesterday() -> Date {
        return calendar.date(byAdding: .day, value: -1, to: Date())!
    }
    
    /// 明天
    public func tomorrow() -> Date {
        return calendar.date(byAdding: .day, value: 1, to: Date())!
    }
    
    /// 上個月
    public func lastMonth() -> Date {
        return calendar.date(byAdding: .month, value: -1, to: Date())!
    }
    
    /// 下個月
    public func nextMonth() -> Date {
        return calendar.date(byAdding: .month, value: 1, to: Date())!
    }
    
    /// 是否在日期區間內
    /// - Parameters:
    ///   - startDate: 起始日期
    ///   - endDate: 結束日期
    ///   - includeBounds: 包含起始結束日期
    /// - Returns: true if the date is between the two given dates.
    public func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        
        if includeBounds {
            
            return startDate.compare(self).rawValue * compare(endDate).rawValue >= 0
        }
        
        return startDate.compare(self).rawValue * compare(endDate).rawValue > 0
    }

    /// SwifterSwift: check if a date is a number of date components of another date
    ///
    /// - Parameters:
    ///   - value: number of times component is used in creating range
    ///   - component: Calendar.Component to use.
    ///   - date: Date to compare self to.
    /// - Returns: true if the date is within a number of components of another date
    public func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        
        let components = calendar.dateComponents([component], from: self, to: date)
        let componentValue = components.value(for: component)!
        
        return abs(componentValue) <= value
    }

    #if !os(Linux)
    /// 取得年/月/日起始時間
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
    ///     let date2 = date.beginning(of: .hour) // "Jan 12, 2017, 7:00 PM"
    ///     let date3 = date.beginning(of: .month) // "Jan 1, 2017, 12:00 AM"
    ///     let date4 = date.beginning(of: .year) // "Jan 1, 2017, 12:00 AM"
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    public func beginning(of component: Calendar.Component) -> Date? {
        
        if component == .day {
            return calendar.startOfDay(for: self)
        }

        var components: Set<Calendar.Component> {
            
            switch component {
            
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]

            case .minute:
                return [.year, .month, .day, .hour, .minute]

            case .hour:
                return [.year, .month, .day, .hour]

            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]

            case .month:
                return [.year, .month]

            case .year:
                return [.year]

            default:
                return []
            }
        }

        guard !components.isEmpty else { return nil }
        
        return calendar.date(from: calendar.dateComponents(components, from: self))
    }

    /// 取得年/月/日結束時間
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.end(of: .day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.end(of: .month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.end(of: .year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    public func end(of component: Calendar.Component) -> Date? {
        
        switch component {
        
        case .second:
            var date = adding(.second, value: 1)
            date = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.add(.second, value: -1)
            return date

        case .minute:
            var date = adding(.minute, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .hour:
            var date = adding(.hour, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .day:
            var date = adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            date.add(.second, value: -1)
            return date

        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = calendar.date(from:
                calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date

        case .month:
            var date = adding(.month, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .year:
            var date = adding(.year, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date

        default:
            return nil
        }
    }
    #endif
}
