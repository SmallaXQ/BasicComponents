
import UIKit

public extension UIImage {
    
    /// 获取视图快照图片
    /// 必须在主线程上执行
    ///
    /// - Parameter view: 需要生成快照的视图
    /// - Returns: 快照图片
    class func snapshot(_ view: UIView) -> UIImage? {
        if !Thread.isMainThread {
            assert(false, "UIImage.\(#function) must be called from main thread only.")
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片进行裁剪
    ///
    /// - Parameters:
    ///   - image: image: 需要处理图片
    ///   - maxSize: 最大尺寸
    ///   - maxDataSize: 图片数据最大值 maxDataSize = 12 代表不超过过12k
    ///   - reduceFrequency: 压缩图片时降低频率
    /// - Returns: 图片data值
    class func generateImageData(image: UIImage, maxSize: CGSize, maxDataSize: Int, reduceFrequency: Double) -> NSData? {
        if ( maxSize.width <= 0 || maxSize.height <= 0)
        {
            return nil;
        }
        
        var tempImage = image.copy() as! UIImage
        
        tempImage = tempImage.imageWithSize(size: maxSize)
        
        var imageData = Data()
        
        for index in stride(from: 1.0, to: 0.0, by: -reduceFrequency) {
            let tepresentationImageData = tempImage.jpegData(compressionQuality: CGFloat(index))
            guard let _ =  tepresentationImageData else {
                return nil
            }
            imageData = tepresentationImageData!
            if ((imageData as NSData).length < maxDataSize * 1024)
            {
                break
            }
        }
        
        if ((imageData as NSData).length  > maxDataSize * 1024)
        {
            return UIImage .generateImageData(image: image, maxSize: CGSize(width: maxSize.width * 0.9, height: maxSize.height * 0.9), maxDataSize: maxDataSize, reduceFrequency: -0.2)
        }
        return imageData as NSData?
    }
    
    class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     缩放图片
     */
    func imageWithSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return currentImage!
    }
    
    func resizeToSize(_ targetSize: CGSize, padding: CGFloat = 0) -> UIImage? {
        let newSize = self.size.scaledSize(targetSize)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect.insetBy(dx: padding, dy: padding))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    ///生成二维码
    class func generateQRCode(_ text: String,_ width:CGFloat,_ fillImage:UIImage? = nil, _ color:UIColor? = nil) -> UIImage? {
        
        //给滤镜设置内容
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            // 设置生成的二维码的容错率
            // value = @"L/M/Q/H"
            filter.setValue("H", forKey: "inputCorrectionLevel")
            
            //获取生成的二维码
            guard let outPutImage = filter.outputImage else {
                return nil
            }
            
            // 设置二维码颜色
            let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":outPutImage,"inputColor0":CIColor(cgColor: color?.cgColor ?? UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])
            
            //获取带颜色的二维码
            guard let newOutPutImage = colorFilter?.outputImage else {
                return nil
            }
            
            let scale = width/newOutPutImage.extent.width
            
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let output = newOutPutImage.transformed(by: transform)
            
            let QRCodeImage = UIImage(ciImage: output)
            
            guard let fillImage = fillImage else {
                return QRCodeImage
            }
            
            let imageSize = QRCodeImage.size
            
            UIGraphicsBeginImageContext(imageSize)
            
            QRCodeImage.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
            
            let fillRect = CGRect(x: (width - width/5)/2, y: (width - width/5)/2, width: width/5, height: width/5)
            
            fillImage.draw(in: fillRect)
            
            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return QRCodeImage }
            
            UIGraphicsEndImageContext()
            
            return newImage
            
        }
        
        return nil
        
    }
    
    
    ///生成条形码
    class func generateCode128(_ text:String, _ size:CGSize,_ color:UIColor? = nil ) -> UIImage?
    {
        //给滤镜设置内容
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setDefaults()
            
            filter.setValue(data, forKey: "inputMessage")
            
            //获取生成的条形码
            guard let outPutImage = filter.outputImage else {
                return nil
            }
            
            // 设置条形码颜色
            let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":outPutImage,"inputColor0":CIColor(cgColor: color?.cgColor ?? UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])
            
            //获取带颜色的条形码
            guard let newOutPutImage = colorFilter?.outputImage else {
                return nil
            }
            
            let scaleX:CGFloat = size.width/newOutPutImage.extent.width
            
            let scaleY:CGFloat = size.height/newOutPutImage.extent.height
            
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            let output = newOutPutImage.transformed(by: transform)
            
            let barCodeImage = UIImage(ciImage: output)
            
            return barCodeImage
            
        }
        
        return nil
    }
}


public extension UIImage {
    // 图片处理
    // 指定大小缩放图片 返回图片
    
    func imageCompressForSizeToTargetSize(sourceImage:UIImage,targetSize:CGSize) ->UIImage{
        // 创建新的图片
        var newImage:UIImage = UIImage()
        let imageSize:CGSize = sourceImage.size
        // 旧图片的宽 高
        let width = imageSize.width
        let height = imageSize.height
        //  新图片的宽 高
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        // 缩放比例
        var scaleFactor:CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint.zero
        
        
        if imageSize.equalTo(size) {
            return sourceImage
        }else{
            // 缩放比例
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor {
                // 为了避免图片缩放后被拉伸，缩放比例 按照长的进行计算
                scaleFactor = widthFactor
            }else{
                scaleFactor = heightFactor
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        // 绘制图形
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in:thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    // 指定宽度按比例缩放
    func imageCompressForWidth( targetWidth:CGFloat) ->UIImage{
        // 创建新的图片
        var newImage:UIImage = UIImage()
        let imageSize:CGSize = self.size
        // 旧图片的宽 高
        let width = imageSize.width
        let height = imageSize.height
        //  新图片的宽 高
        let targetWidth = targetWidth
        let targetHeight = height / width * targetWidth
        let size = CGSize(width: targetWidth, height: targetHeight)
        
        // 缩放比例
        var scaleFactor:CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint.zero
        if imageSize.equalTo(size) {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(size)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        self.draw(in:thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return newImage
        
    }
}
