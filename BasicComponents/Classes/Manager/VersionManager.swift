
import UIKit

/*
 *  版本管理
 */
public class VersionManager {
    
    // 返回版本比较结果，如果"localVersion >= appStoreVersion"，则返回false，不更新；如果"localVersion < appStoreVersion"，则返回true，提示更新。
    public class func versionCompare(_ appStoreVersion: String, localVersion: String) -> Bool {
                
        //判断合法性
        if checkSeparat(localVersion) == "" || checkSeparat(appStoreVersion) == "" {
            return false
        }
        //获得两个数组
        let localVersionArr = cutUpNumber(localVersion)
        let appStoreVersionArr = cutUpNumber(appStoreVersion)
        //比较版本号
        return compareNumber(with: localVersionArr, appStoreVersionArr: appStoreVersionArr)
    }
    
    //提取连接符
    public class func checkSeparat(_ vString:String) -> String {
        var separated:String = ""
        if vString.contains("."){ separated = "." }
        if vString.contains("-"){ separated = "-" }
        if vString.contains("/"){ separated = "/" }
        if vString.contains("*"){ separated = "*" }
        if vString.contains("_"){ separated = "_" }
        
        return separated
    }
    
    //提取版本号
    public class func cutUpNumber(_ vString:String) -> Array<String> {
        let separat = checkSeparat(vString)
        let b = NSCharacterSet(charactersIn:separat) as CharacterSet
        let vStringArr = vString.components(separatedBy: b)
        return vStringArr
    }
    
    //比较版本
    public class func compareNumber(with localVersionArr: [String], appStoreVersionArr: [String]) -> Bool {
        
        for i in 0..<localVersionArr.count {
            
            if appStoreVersionArr.count <= i {
                return false
            }
            if (localVersionArr[i] as NSString).integerValue != (appStoreVersionArr[i] as NSString).integerValue {
                if (localVersionArr[i] as NSString).integerValue > (appStoreVersionArr[i] as NSString).integerValue {
                    return false
                }else{
                    return true
                }
            }
        }
        return false
    }
}
