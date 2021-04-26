//
//  StringExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/21.
//

import Foundation

extension String {
    
    //MARK: - Parameters
    
    /// youtube 影片ID
    public var youtubeID: String? {
        
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
    /// youtube 影片網址
    public var youtubeVideo: String? {
        
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        let youtubeID = (self as NSString).substring(with: result.range)
        let youtubeVideo = String(format: "http://www.youtube.com/embed/%@", youtubeID)
        
        return youtubeVideo
    }
    
    /// youtube 縮圖網址
    public var youtubeThumbnailImageUrl: String? {
        
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        let youtubeID = (self as NSString).substring(with: result.range)
        let youtubeThumbnailImage = String(format: "https://img.youtube.com/vi/%@/hqdefault.jpg", youtubeID)
        
        return youtubeThumbnailImage
    }
    
    /// URL轉可讀字串
    public var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// 可讀字串轉URL
    public var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    /// 字串是否包含字母
    public var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// 字串是否包含數字
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// 字串是否只有字母, 不含數字
    public var isAlphabetic: Bool {
        
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        
        return hasLetters && !hasNumbers
    }
    
    /// 字串是否包含一個字母與一個數字
    public var isAlphaNumeric: Bool {
        
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// 是否為https網址
    public var isValidHttpsUrl: Bool {
        
        guard let url = URL(string: self) else { return false }
        
        return url.scheme == "https"
    }
    
    /// 是否為http網址
    public var isValidHttpUrl: Bool {
        
        guard let url = URL(string: self) else { return false }
        
        return url.scheme == "http"
    }
    
    /// 字串是否包含表情符號
    public var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            
            switch scalar.value {
            
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
                
            default:
                continue
            }
        }
        return false
    }
    
    //MARK: - Functions
    
    /// 檢查email格式
    public func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return predicate.evaluate(with: self)
    }
    
    /// 檢查格式，是否符合 開頭是英文字母＋後面9個數字
    public func isValidPersonalID() -> Bool {
        
        let regex: String = "^[a-z]{1}[1-2]{1}[0-9]{8}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        
        return predicate.evaluate(with: self)
    }
    
    /// 多語系字串
    public func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    /// 移除字串前後空白
    public func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /// 字串取代
    /// - Parameters:
    ///   - target: 欲取代的文字
    ///   - withString: 取代的文字
    public func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /// 文字長度檢查
    /// - Parameters:
    ///   - length: 檢查長度
    /// - Returns: Bool
    public func lengthCheck(length: Int) -> Bool {
        
        if self.count < length {
            
            return true
            
        }else{
            
            return false
        }
    }
    
    /// 文字長度檢查
    /// - Parameters:
    ///   - min: 檢查長度最小值
    ///   - max: 檢查長度最大值
    /// - Returns: Bool
    public func lengthCheck(min: Int, max: Int) -> Bool {
        
        if min <= self.count && self.count <= max {
            
            return true
            
        }else{
            
            return false
        }
    }
    
    /// 字串轉布林
    public func toBool() -> Bool {
        
        switch self {
        
        case "True", "true", "yes", "1":
            return true
            
        case "False", "false", "no", "0":
            return false
            
        default:
            return false
        }
    }
    
    /// 從第0個字數, 擷取字串到Index位置
    /// - Parameter index: 字串長度
    public func slice(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    /// 從Index位置, 擷取字串到結尾
    /// - Parameter index: 字串長度
    public func slice(at index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    /// 擷取字串
    /// - Parameters:
    ///   - index: 起始位置
    ///   - length: 長度
    public func slicing(from index: Int, length: Int) -> String? {
        
        guard length >= 0, index >= 0, index < count  else { return nil }
        
        guard index.advanced(by: length) <= count else {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: count)
            return String(self[startIndex..<endIndex])
        }
        
        guard length > 0 else { return "" }
        
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.index(self.startIndex, offsetBy: index.advanced(by: length))
        
        return String(self[startIndex..<endIndex])
    }
        
    /// 日期轉換成民國年
    /// - Parameter format: 日期時間格式
    public func TransToTWDateFormat(format: DateTimeFormat = .Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let newDate = dateFormatter.date(from: self)
        
        var calendar = Calendar.current
        calendar = .current
        let year = calendar.component(.year, from: newDate!)
        let month = calendar.component(.month, from: newDate!)
        let day = calendar.component(.day, from: newDate!)
        
        var newMonth = "", newDay = "", newYear = ""
        
        if (month < 10) {
            newMonth = String(format: "%02d", month)
        } else {
            newMonth = String(month)
        }
        
        if (day < 10) {
            newDay = String(format: "%02d", day)
        } else {
            newDay = String(day)
        }
        
        newYear = String(year - 1911)
        
        let strDate: String!
        
        switch dateFormatter.dateFormat {
            
        case DateTimeFormat.Date.rawValue:
            strDate = String(format: "%@-%@-%@", newYear, newMonth, newDay)
            break
            
        case DateTimeFormat.DateSlash.rawValue:
            strDate = String(format: "%@/%@/%@", newYear, newMonth, newDay)
            break
            
        case DateTimeFormat.DateTime.rawValue:
            let hour = calendar.component(.hour, from: newDate!)
            let min = calendar.component(.minute, from: newDate!)
            strDate = String(format: "%@-%@-%@ %02d:%02d", newYear, newMonth, newDay, hour, min)
            break
            
        case DateTimeFormat.DateTimeSlash.rawValue:
            let hour = calendar.component(.hour, from: newDate!)
            let min = calendar.component(.minute, from: newDate!)
            strDate = String(format: "%@/%@/%@ %02d:%02d", newYear, newMonth, newDay, hour, min)
            break
            
        case DateTimeFormat.YearMonth.rawValue:
            strDate = String(format: "%@-%@", newYear, newMonth)
            break
            
        case DateTimeFormat.YearMonthSlash.rawValue:
            strDate = String(format: "%@/%@", newYear, newMonth)
            break
            
        default:
            strDate = String(format: "%@-%@-%@", newYear, newMonth, newDay)
            break
        }
        
        return strDate
    }
    
    /// 轉UTF8編碼字串
    public func utf8EncodedString() -> String {
        
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        
        return text ?? ""
    }

    /// 轉換成日期
    /// - Parameter format: 轉換格式
    /// - Returns: Date
    public func toDate(format: DateTimeFormat = .Date) -> Date? {
        
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format.rawValue
        
        return formatter.date(from: selfLowercased)
    }
    
    /// 轉換成日期時間
    /// - Parameter format: 轉換格式
    /// - Returns: Date
    public func toDateTime(format: DateTimeFormat = .DateTime) -> Date? {
        
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format.rawValue
        
        return formatter.date(from: selfLowercased)
    }
    
    /// 字串根據換行符號切割
    public func lines() -> [String] {
        
        var result = [String]()
        
        enumerateLines { line, _ in
            result.append(line)
        }
        
        return result
    }
}
