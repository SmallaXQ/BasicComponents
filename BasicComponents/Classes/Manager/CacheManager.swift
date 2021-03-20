
import UIKit

/*
 *  缓存管理类
 */
public class CacheManager: NSObject {
    
    /// 获取缓存大小
    public class func getCacheSize() -> Double {
        
        /// 本地沙盒目录下的缓存
        // 取出cache文件夹目录
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return 0
        }
                
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath) ?? []
        
        guard fileArr.count > 0 else {
            return 0
        }
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr {
            
            // 把文件名拼接到路径中
            let path = cachePath + ("/\(file)")
            // 取出文件属性
            if let floder = try? FileManager.default.attributesOfItem(atPath: path) {
                // 用元组取出文件大小属性
                for (key, fileSize) in floder {
                    // 累加文件大小
                    if key == FileAttributeKey.size {
                        size += (fileSize as AnyObject).integerValue
                    }
                }
            }
        }
        
        let totalCache = Double(size) / 1024.00 / 1024.00
        return totalCache
    }
    
    /// 清除缓存
    public class func clearCache(with completion: ((Double)->())?) {
        // 取出cache文件夹目录
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let fileArr = FileManager.default.subpaths(atPath: cachePath) ?? []
            guard fileArr.count > 0 else {
                completion?(0)
                return
            }
            // 遍历删除
            for file in fileArr {
                let path = (cachePath as NSString).appending("/\(file)")
                if FileManager.default.fileExists(atPath: path) {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                    }
                }
            }
            let DoubleSize = CacheManager.getCacheSize()
            completion?(DoubleSize)
        } else {
            completion?(0)
        }
    }
    
    /// 获取缓存路径
    public class func getCachFolderpath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first
        let cachePath = (documentsDirectory! as NSString).appendingPathComponent("Caches")
        let fileManagers = FileManager.default
        if !fileManagers.fileExists(atPath: cachePath) {
            do {
                try fileManagers.createDirectory(atPath: cachePath, withIntermediateDirectories: false, attributes: nil)
            } catch  {
                _ = error as NSError
            }
        }
        return cachePath
    }
    
    /// 缓存中读取数据
    public class func read (path: String) -> NSData? {
        
        if FileManager.default.fileExists(atPath: path) {
            return NSData(contentsOfFile: path)
        }
        return nil
    }
    
    /// 向指定路径中缓存数据
    public class func cache(withfilePath filePath: String, data: Data) {
        if !FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
        // 清除文件，再存入
        do {
            try FileManager.default.removeItem(atPath: filePath)
            try (data as NSData).write(toFile: filePath, options: .atomicWrite)
        } catch _ {
        }
    }
    
    /// 清除指定路径下的缓存数据
    public class func removeCache(from filePath: String) {
        
        guard FileManager.default.fileExists(atPath: filePath) else {
            return
        }
        // 清除文件
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch _ {
        }
    }
    
    /// 商品图片缓存路径（文件夹）
    public class func getImageCachePath() -> String {
        let imageCacheFolderPath = (CacheManager.getCachFolderpath() as NSString).appendingPathComponent("imageCatchs")
        return imageCacheFolderPath
    }
    
    /// 图片缓存子路径（单个文件）
    public class func imageCachePath(_ imageName: String) -> String {
        let imageCacheFolderPath = (CacheManager.getCachFolderpath() as NSString).appendingPathComponent("imageCatchs")
        let imageCachePath = (imageCacheFolderPath as NSString).appendingPathComponent(imageName)
        return imageCachePath
    }
    
    /// 判断图片缓存是否存在
    public class func imageCacheIsExist() -> Bool {
        let filePath = CacheManager.getImageCachePath()
        return FileManager.default.fileExists(atPath: filePath)
    }
}
