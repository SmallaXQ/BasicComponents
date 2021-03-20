
import UIKit
import CommonCrypto

public extension String {
    
    var md5: String! {
        guard let data = data(using: .utf8) else { return self }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    /**
     截取超出部分字符串
     - parameter max : 要截取的位数
     - returns: 截取之后的长度
     */
    mutating func stringCutWithMaxLength(_ max: Int) {
        if self.count < max {
            return
        }
        self.replaceSubrange(self.index(self.startIndex, offsetBy: max)..<self.endIndex, with: "")
    }
    
    /**
     字符串长度
     - returns: 字符串长度,包括空格等
     */
    var length: Int {
        return count
    }
    
    /**
     去除字符串中的空格
     - returns: 去除字符串中的空格之后的字符
     */
    func trimSpace() -> String {
        let newSharacters = filter { (c) -> Bool in
            return c == " " ? false : true
        }
        
        var newStr = ""
        for c in newSharacters {
            newStr = newStr + String(c)
        }
        return newStr
    }
    
    /**
     将编码后的url转换回原始的url
     */
    func URLDecode() -> String? {
        return self.removingPercentEncoding
    }
    
    /**
     编码url
     */
    func URLEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]% ").inverted)
    }
    
    /**
     根据字体获取宽度
     */
    func sizeWith(font: UIFont) -> CGSize {
        let text = self as NSString
        let size = text.size(withAttributes: [NSAttributedString.Key.font : font])
        return size
    }
    
    // 根据文案内容和字体、高度计算文案宽度
    func getWith(_ font: UIFont, height: CGFloat) -> CGSize {
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        let dic = [NSAttributedString.Key.font: font]
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context: nil).size
        return strSize
    }
    
    /**
     * 获取attrbuteTexts富文本
     */
    func attrbuteTexts(text: String ..., color: UIColor, font: UIFont) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: self)
        // 中间变量 可变 text, 解决当传入的text有相同元素的时候，定位Range
        var mutiText = self
        
        for t in text {
            if mutiText.contains(t) {
                let range = (mutiText as NSString).range(of: t)
                
                // mutiText
                var repalceStr = ""
                for _ in 0..<(range.length) {
                    repalceStr = repalceStr + " "
                }
                mutiText = (mutiText as NSString).replacingCharacters(in: range, with: repalceStr)
                
                
                let c = color
                let f = font
                
                attr.addAttributes([NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: f], range: range)
            }
        }
        return attr
    }
    
    /**
     限制输入框输入内容
     如果string字符集每一个字符都是text字符集的子集，返回true，否则返回false
     eg: let limit = String.limitInputText("0123456789Xx", string: "3cf5")
     limit = false
     - parameter text     :字符集
     - parameter string   :等待校验的字符集
     - returns: 校验结果
     */
    static func limitInputText(_ text: String, string: String) -> Bool {
        let character = CharacterSet(charactersIn: text).inverted
        let filter = string.components(separatedBy: character) as NSArray
        let bTest = string.isEqual(filter.componentsJoined(by: ""))
        
        return bTest
    }
    
    func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }

    // 匹配阿里云尺寸规则
    func withOSSRule(_ oss: String) -> String {
        return self + "?x-oss-process=style/\(oss)"
    }
}

extension String {
    // String类型转换
    public var intValue: Int32 {
        return (self as NSString).intValue
    }
    public var integerValue: NSInteger {
        return (self as NSString).integerValue
    }
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    public var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    public var boolValue: Bool {
        return (self as NSString).boolValue
    }
    // 匹配字符串，拿到range
    public func rangeOfString(str: String) -> NSRange {
        return (self as NSString).range(of: str)
    }
    // 根据str替换
    public func replaceStr(ofStr: String, withStr: String) -> String {
        return (self as NSString).replacingOccurrences(of: ofStr, with: withStr)
    }
    // 据range替换
    public func replaceRange(inRange: NSRange, withStr: String) -> String {
        return (self as NSString).replacingCharacters(in: inRange, with: withStr)
    }
    // 字符串去空格
    public func deleteSpace() -> String {
        return self.replaceStr(ofStr: " ", withStr: "")
    }
    /// 截取到任意位置
    public func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    public func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    public func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    public subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    public subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
}
