

import Foundation
import UIKit

// ============== 机型判断 =================== //

/// Apple iPhone4机型
public let iPhone4 = UIScreen.main.bounds.height == 480

/// Apple iPhone5机型
public let iPhone5 = UIScreen.main.bounds.height == 568

/// Apple iPhone6机型
public let iPhone6 = UIScreen.main.bounds.height == 667

/// Apple iPhone 6、6s、7、8等Plus机型
public let iPhonePlus = UIScreen.main.bounds.height == 736

/// 苹果iPhone X、iPhone XS、iPhone 11 Pro 机型
public let iPhoneX_XS = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? UIScreen.main.currentMode!.size.equalTo(CGSize(width: 1125, height: 2436)) : false

/// 苹果iPhone XR、iPhone 11 机型
public let iPhoneXR = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? UIScreen.main.currentMode!.size.equalTo(CGSize(width: 828, height: 1792)) : false

/// 苹果iPhone XS Max、iPhone 11 Pro Max 机型
public let iPhoneXSMax = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? UIScreen.main.currentMode!.size.equalTo(CGSize(width: 1242, height: 2688)) : false

/// 苹果iPhone 12 mini机型
public let iPhone12Mini = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? UIScreen.main.currentMode!.size.equalTo(CGSize(width: 1080, height: 2340)) : false

/// 苹果iPhone 12、iPhone 12 Pro 机型
public let iPhone12 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? UIScreen.main.currentMode!.size.equalTo(CGSize(width: 1170, height: 2532)) : false

/// 苹果iPhone 12 Pro Max 机型
public let iPhone12ProMax = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? UIScreen.main.currentMode!.size.equalTo(CGSize(width: 1284, height: 2778)) : false

/// Apple iPhone4或者5机型（小屏机型统一判断）
public let iPhone_4_5 = UIScreen.main.bounds.width == 320 ? true : false

/// 是否为iPhone X / XS / XR / XS Max / 11 / 11 Pro / 11 Pro Max系列
public var isIPhoneXSeries: Bool {
    var iPhoneXSeries = false
    if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
        return iPhoneXSeries
    }
    
    if #available(iOS 11.0, *)  {
        if let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom {
            if bottom > CGFloat(0.0) {
                iPhoneXSeries = true
            }
        }
    }
    return iPhoneXSeries
}

/// 获取iPhone X机型的安全区域高度
public func iphoneXSafeAreaInsets() -> UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    } else {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


// ============== 屏幕判断 =================== //

/// 当前屏幕高度
public let ScreenWidth = UIScreen.main.bounds.width

/// 当前屏幕高度
public let ScreenHeight = UIScreen.main.bounds.height


// ============== 按比例适配宽高，以750*1334为基准 =================== //

// 宽度比
public func scaleWidth(_ w: CGFloat) -> CGFloat {
    return ScreenWidth / 375 * w
}

// 高度比列
public func scaleHeight(_ h: CGFloat) -> CGFloat {
    return ScreenHeight / 667 * h
}


/// Documents 目录：您应该将所有的应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
public let DocumentPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

/// Application
public let SharedApplication = UIApplication.shared

/// AppDelegate
internal let SharedAppDelegate = UIApplication.shared.delegate

/// Main Window
public let AppMainWindow = UIApplication.shared.windows.first

/// Root View Controller
public let RootViewController = UIApplication.shared.delegate?.window??.rootViewController

/// Main Screen
public let AppMainScreen = UIScreen.main

/// Standard UserDefaults
public let StandardUserDefaults = UserDefaults.standard

/// Default Notification Center
public let DefaultNotificationCenter = NotificationCenter.default

/// Default File Manager
public let DefaultFileManager = FileManager.default

/// Main Bundle
public let MainBundle = Bundle.main

/// Status Bar 默认高度
public let StatusBarDefaultHeight: CGFloat = isIPhoneXSeries ? 44.0 : 20.0

/// Navigation Bar 默认高度
public let NavigationBarDefaultHeight: CGFloat = 44.0

/// Tab Bar 默认高度
public let TabBarDefaultHeight: CGFloat = 49.0

/// Top Layout 默认高度
public var TopLayoutDefaultHeight: CGFloat {
    return StatusBarDefaultHeight + NavigationBarDefaultHeight
}
