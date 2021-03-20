
import Foundation

public class PlistTool: NSObject {
    
    /**
     备份Plist
     
     - parameter name: Plist 文件名
     
     */
    public static func backUp(name: String) {
        let pathURL = Bundle.main.bundleURL.appendingPathComponent(name)
        let array = NSMutableArray(contentsOf: pathURL)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = path + "/\(name)"
        
        
        let newArray = PlistTool.readArrayFrom(plist: name)
        guard newArray != nil else {
            array?.write(toFile: fileName, atomically: true)
            return
        }
    }
    
    /**
     写入Plist
     
     - parameter array: 数组
     - parameter toPlist: Plist文件名
     
     */
    public static func write(array: Array<Any>, toPlist: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = path + "/\(toPlist)"
        let newArray = NSArray(array: array)
        newArray.write(toFile: fileName, atomically: true)
    }
    
    /**
     读取Plist
     
     - parameter toPlist: Plist文件名
     - return: 返回数组
     
     */
    public static func readArrayFrom(plist: String) -> NSMutableArray? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = path + "/\(plist)"
        let data = NSMutableArray(contentsOfFile: fileName)
        return data
    }
    
    /// 清除plist文件
    ///
    /// - Parameter plist: 文件名
    public static func remove(_ plist: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = path + "/\(plist)"
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileName) {
            do {
                try fileManager.removeItem(atPath: fileName)
            } catch _ {
            }
        }
    }
    
    /// 字典类型数据写入沙盒
    ///
    /// - Parameters:
    ///   - dic: 字典类型数据
    ///   - toPlist: 文件名
    public static func write(dic: [String : Any], toPlist: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = path + "/\(toPlist)"
        let newDic = NSDictionary(dictionary: dic)
        newDic.write(toFile: fileName, atomically: true)
    }
    
    /// 从沙盒读取字典类型数据
    ///
    /// - Parameter plist: 文件名
    /// - Returns: 字典类型数据
    public static func readDicFrom(plist: String) -> NSDictionary? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = path + "/\(plist)"
        let data = NSDictionary(contentsOfFile: fileName)
        return data
    }
}
