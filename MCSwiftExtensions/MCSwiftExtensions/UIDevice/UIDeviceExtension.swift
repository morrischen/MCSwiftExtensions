//
//  UIDeviceExtension.swift
//  MCSwiftExtensions
//
//  Created by 陳堃維 on 2021/4/22.
//

import Foundation
import UIKit

//MARK: - Enum

public enum Devices: String {
    
    /// iPhone Series
    case iPhone6
    case iPhone6Plus
    case iPhone6s
    case iPhone6sPlus
    case iPhoneSE
    case iPhone7
    case iPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhoneSE2
    case iPhone12Mini
    case iPhone12
    case iPhone12Pro
    case iPhone12ProMax
    
    /// iPad Series
    case iPad2
    case iPad3
    case iPad4
    case iPad5
    case iPad6
    case iPad7
    case iPadAir
    case iPadAir2
    case iPadAir3
    case iPadAir4
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadMini5
    case iPadPro_9_7
    case iPadPro_12_9
    case iPadPro2_12_9
    case iPadPro_10_5
    case iPadPro_11
    case iPadPro3_12_9
    case iPadPro4_12_9
    case Simulator
    case Other
}

public enum Network: String {
    case Wifi = "en0"
    case Cellular = "pdp_ip0"
}

extension UIDevice {
    
    //MARK: - Parameters
    
    public var udid: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    public var ipAddress: String {
        
        guard let url = URL(string: "https://checkip.amazonaws.com") else {
            return UIDevice.current.ipv4(for: .Cellular) ?? ""
        }
        
        do {
            
            let ipAddress = try String(contentsOf: url).replace(target: "\n", withString: "")
            return ipAddress
            
        } catch let error {
            print("get public address error: \(error)")
            return UIDevice.current.ipv4(for: .Cellular) ?? ""
        }
    }
    
    //MARK: - Functions
    
    /// get ip address
    /// - Parameters:
    ///   - family: internetwork: UDP, TCP, etc.
    ///   - network: network interface
    /// - Returns: ip address
    public func address(family: Int32, for network: Network) -> String? {
        var address: String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(family) {
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    /// get ipv4 ip address
    /// - Parameter network: network interface
    /// - Returns: ip address
    public func ipv4(for network: Network) -> String? {
        self.address(family: AF_INET, for: network)
    }
    
    /// get ipv6 ip address
    /// - Parameter network: network interface
    /// - Returns: ip address
    public func ipv6(for network: Network) -> String? {
        self.address(family: AF_INET6, for: network)
    }
    
    /// get all addresses
    /// - Returns: get address string array
    public func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        
        return addresses
    }
    
    /// 獲取設備的具體型號
    public var modelName: Devices {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        
        /// iPhone Series
        case "iPhone7,2":                                 return .iPhone6
        case "iPhone7,1":                                 return .iPhone6Plus
        case "iPhone8,1":                                 return .iPhone6s
        case "iPhone8,2":                                 return .iPhone6sPlus
        case "iPhone8,3",  "iPhone8,4":                   return .iPhoneSE
        case "iPhone9,1",  "iPhone9,3":                   return .iPhone7
        case "iPhone9,2",  "iPhone9,4":                   return .iPhone7Plus
        case "iPhone10,1", "iPhone10,4":                  return .iPhone8
        case "iPhone10,2", "iPhone10,5":                  return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6":                  return .iPhoneX
        case "iPhone11,2":                                return .iPhoneXS
        case "iPhone11,4", "iPhone11,6":                  return .iPhoneXSMax
        case "iPhone11,8":                                return .iPhoneXR
        case "iPhone12,1":                                return .iPhone11
        case "iPhone12,3":                                return .iPhone11Pro
        case "iPhone12,5":                                return .iPhone11ProMax
        case "iPhone12,8":                                return .iPhoneSE2
        case "iPhone13,1":                                return .iPhone12Mini
        case "iPhone13,2":                                return .iPhone12
        case "iPhone13,3":                                return .iPhone12Pro
        case "iPhone13,4":                                return .iPhone12ProMax
            
        /// iPad Series
        case "iPad2,1",  "iPad2,2", "iPad2,3", "iPad2,4": return .iPad2
        case "iPad3,1",  "iPad3,2", "iPad3,3":            return .iPad3
        case "iPad3,4",  "iPad3,5", "iPad3,6":            return .iPad4
        case "iPad6,11", "iPad6,12":                      return .iPad5
        case "iPad7,5",  "iPad7,6":                       return .iPad6
        case "iPad7,11", "iPad7,12":                      return .iPad7
        case "iPad4,1",  "iPad4,2", "iPad4,3":            return .iPadAir
        case "iPad5,3",  "iPad5,4":                       return .iPadAir2
        case "iPad11,4", "iPad11,5":                      return .iPadAir3
        case "iPad13,1", "iPad13,2":                      return .iPadAir4
        case "iPad2,5",  "iPad2,6", "iPad2,7":            return .iPadMini
        case "iPad4,4",  "iPad4,5", "iPad4,6":            return .iPadMini2
        case "iPad4,7",  "iPad4,8", "iPad4,9":            return .iPadMini3
        case "iPad5,1",  "iPad5,2":                       return .iPadMini4
        case "iPad11,1", "iPad11,2":                      return .iPadMini5
        case "iPad6,3",  "iPad6,4":                       return .iPadPro_9_7
        case "iPad6,7",  "iPad6,8":                       return .iPadPro_12_9
        case "iPad7,1",  "iPad7,2":                       return .iPadPro2_12_9
        case "iPad7,3",  "iPad7,4":                       return .iPadPro_10_5
        case "iPad8,1",  "iPad8,2", "iPad8,3", "iPad8,4": return .iPadPro_11
        case "iPad8,5",  "iPad8,6", "iPad8,7", "iPad8,8": return .iPadPro3_12_9
        case "iPad8,11", "iPad8,12":                      return .iPadPro4_12_9
        case "i386", "x86_64":                            return .Simulator
        default:                                          return .Other
        }
    }
}
