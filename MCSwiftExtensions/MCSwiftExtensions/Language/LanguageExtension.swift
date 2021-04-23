//
//  LanguageExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation

//MARK: - Enum

public enum Language: Equatable, Hashable {
    case English(English)
    case Chinese(Chinese)
    case Korean
    case Japanese
}

public enum Chinese {
    case Simplified
    case Traditional
    case HongKong
}

public enum English {
    case US
    case UK
    case Australian
    case Canadian
    case Indian
}

extension Language {
    
    //MARK: - Parameters

    public var code: String {
        
        switch self {
        
        case .English(let english):
            
            switch english {
            
            case .US:                return "en"
            case .UK:                return "en-GB"
            case .Australian:        return "en-AU"
            case .Canadian:          return "en-CA"
            case .Indian:            return "en-IN"
                
            }

        case .Chinese(let chinese):
            
            switch chinese {
            
            case .Simplified:       return "zh-Hans"
            case .Traditional:      return "zh-Hant"
            case .HongKong:         return "zh-HK"
                
            }

        case .Korean:               return "ko"
        case .Japanese:             return "ja"
            
        }
    }

    public var name: String {
        
        switch self {
        
        case .English(let english):
            
            switch english {
            
            case .US:                return "English"
            case .UK:                return "English (UK)"
            case .Australian:        return "English (Australia)"
            case .Canadian:          return "English (Canada)"
            case .Indian:            return "English (India)"
                
            }

        case .Chinese(let chinese):
            
            switch chinese {
            
            case .Simplified:       return "简体中文"
            case .Traditional:      return "繁體中文"
            case .HongKong:         return "繁體中文 (香港)"
                
            }

        case .Korean:               return "한국어"
        case .Japanese:             return "日本語"
            
        }
    }
    
    //MARK: - Functions
    
    /// get language code
    /// - Parameter languageCode: languageCode
    init?(languageCode: String?) {
        
        guard let languageCode = languageCode else { return nil }
        
        switch languageCode {
        
        case "en", "en-US":     self = .English(.US)
        case "en-GB":           self = .English(.UK)
        case "en-AU":           self = .English(.Australian)
        case "en-CA":           self = .English(.Canadian)
        case "en-IN":           self = .English(.Indian)

        case "zh-Hans":         self = .Chinese(.Simplified)
        case "zh-Hant":         self = .Chinese(.Traditional)
        case "zh-HK":           self = .Chinese(.HongKong)

        case "ko":              self = .Korean
        case "ja":              self = .Japanese
            
        default:                return nil
            
        }
    }
}
