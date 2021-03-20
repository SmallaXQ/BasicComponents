
import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreTelephony.CTCarrier
import CoreTelephony.CTTelephonyNetworkInfo
import FCUUID

public struct BasicTool {
    
    public static var networkStatus = ""
    
    //设备唯一码
    public static func getUUID() -> String{
        return FCUUID.uuidForDevice()
    }
    
    //获取app名称
    public static func getAppDisplayName() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    //获取app版本号
    public static func getAppVersion() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    //获取app build号
    public static func getAppBuild() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    //获取操作系统
    public static func getOS() -> String{
        return "iOS"
    }
    
    //获取操作系统版本
    public static func getOSVersion() -> String{
        return UIDevice.current.systemVersion as String
    }
    
    //获取手机品牌
    public static func getMobileBrand() -> String{
        return "Apple"
    }
    
    //获取手机型号
    public static func getMobileVersion() -> String{
        var modelName: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            
            switch identifier {
            case "iPod5,1":                                  return "iPod Touch 5"
            case "iPod7,1":                                  return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return "iPhone 4"
            case "iPhone4,1":                                return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                   return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                   return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                   return "iPhone 5s"
            case "iPhone7,2":                                return "iPhone 6"
            case "iPhone7,1":                                return "iPhone 6 Plus"
                
            case "iPhone8,1":                                return "iPhone 6s"
            case "iPhone8,2":                                return "iPhone 6s Plus"
            case "iPhone8,4":                                return "iPhone SE (1st generation)"
                
            case "iPhone9,1":                                return "iPhone 7 (CDMA)"
            case "iPhone9,2":                                return "iPhone 7 Plus(CDMA)"
            case "iPhone9,3":                                return "iPhone 7 (GSM)"
            case "iPhone9,4":                                return "iPhone 7 Plus (GSM)"
                
            case "iPhone10,1":                               return "iPhone 8 (CDMA)"
            case "iPhone10,4":                               return "iPhone 8 (GSM)"
            case "iPhone10,2":                               return "iPhone 8 Plus (CDMA)"
            case "iPhone10,5":                               return "iPhone 8 Plus (GSM)"
            case "iPhone10,3":                               return "iPhone X (CDMA)"
            case "iPhone10,6":                               return "iPhone X (GSM)"
                
            case "iPhone11,2":                               return "iPhone XS"
            case "iPhone11,4":                               return "iPhone XS Max"
            case "iPhone11,6":                               return "iPhone XS Max"
            case "iPhone11,8":                               return "iPhone XR"
                
            case "iPhone12,1":                               return "iPhone 11"
            case "iPhone12,3":                               return "iPhone 11 Pro"
            case "iPhone12,5":                               return "iPhone 11 Pro Max"
            case "iPhone12,8":                               return "iPhone SE (2nd generation)"
                
            case "iPhone13,1":                               return "iPhone 12 mini"
            case "iPhone13,2":                               return "iPhone 12"
            case "iPhone13,3":                               return "iPhone 12 Pro"
            case "iPhone13,4":                               return "iPhone 12 Pro Max"
                
            case "iPad1,1":                                  return "iPad"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":            return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":            return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                     return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                       return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                     return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                     return "iPad (8th generation)"
                
            case "iPad4,1", "iPad4,2", "iPad4,3":            return "iPad Air"
            case "iPad5,3", "iPad5,4":                       return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                     return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                     return "iPad Air (4th generation)"
                
            case "iPad2,5", "iPad2,6", "iPad2,7":            return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":            return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":            return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                       return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                     return "iPad mini (5th generation)"
                
            case "iPad6,7", "iPad6,8":                       return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                       return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                     return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad6,3", "iPad6,4":                       return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                       return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch)"
            case "iPad8,9", "iPad8,10":                      return "iPad Pro (11-inch) (2nd generation)"
            
                
            case "AppleTV5,3":                               return "Apple TV"
            case "i386", "x86_64":                           return "Simulator"
            default:                                         return identifier
            }
        }
        return modelName
    }
    
    //获取IMSI
    public static func getIMSI() -> String{
        let info: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        if info.subscriberCellularProvider == nil{
            return ""
        }
        let carrier: CTCarrier = info.subscriberCellularProvider!
        let mcc = carrier.mobileCountryCode
        let mnc = carrier.mobileNetworkCode
        if mcc == nil || mnc == nil {
            return ""
        }
        return mcc! + mnc!
    }
    
    //获取手机运营商
    public static func getMobileProvider() -> String{
        let info: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        if info.subscriberCellularProvider == nil{
            return "other"
        }
        let carrier: CTCarrier = info.subscriberCellularProvider!
        let mobileProvider = carrier.carrierName as String? ?? ""
        switch mobileProvider {
        case "中国移动":
            return "mobile"
        case "中国电信":
            return "telecom"
        case "中国联通":
            return "unicom"
        default:
            return "other"
        }
    }
    
    //获取MAC地址
    public static func getMACAddress() -> String{
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            return self.getWifiInfo(array: cfa, keys: "BSSID")
        }
        return ""
    }
    
    //获取wifi名字
    public static func getWIFIName() -> String{
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            return self.getWifiInfo(array: cfa, keys: "SSID")
        }
        return ""
    }
    
    /* 获取WiFi数据 */
    public static func getWifiInfo(array:NSArray,keys key:String) -> String {
        for x in array {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                let ssid = dict[key]! as? String ?? ""
                return ssid
            }
        }
        return ""
    }
    
    public static func isConnectedToNetwork6() -> Bool {// 适用于IPV6协议
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, { pointer in
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        var flags = SCNetworkReachabilityFlags.connectionAutomatic
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    public static func isConnectedToNetwork4() -> Bool {//适用于IPV4协议
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, { pointer in
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        
        var flags = SCNetworkReachabilityFlags.connectionAutomatic
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    /// 判断当前系统版本与参数中的版本如果当前版本大于等于参数版本返回true，返回true
    public static func currentVersionIsgteSystem(systemVersion: Float) -> Bool
    {
        let version = UIDevice.current.systemVersion
        return (version as NSString).floatValue >= systemVersion ? true : false
    }
}
