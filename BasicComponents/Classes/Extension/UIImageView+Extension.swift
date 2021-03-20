
import UIKit
import SDWebImage

public extension UIImageView {
    
    /// 用SDWebImage加载网络图片
    /// - Parameters:
    ///   - urlStr: 图片Url地址
    ///   - placeHolderImage: 默认占位图
    ///   - completion: 回调加载完成之后的图片
    func load(with urlStr: String, placeHolderImage: UIImage? = nil, completion: ((UIImage)->())? = nil) {
        
        if urlStr.length <= 0 {
            return
        }
        let url = URL(string: urlStr)
        if let img = placeHolderImage {
            self.sd_setImage(with: url, placeholderImage: img) { (image, error, type, url) in
                if let currentImage = image {
                    completion?(currentImage)
                }
            }
        }else{
            self.sd_setImage(with: url) { (image, error, type, url) in
                if let currentImage = image {
                    completion?(currentImage)
                }
            }
        }
    }
}
