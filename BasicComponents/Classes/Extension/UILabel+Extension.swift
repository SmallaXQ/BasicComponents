
import Foundation

extension UILabel {
    //同一段文案 一个部分色值、字体变化
    public func attributeText(text: String, color: UIColor? = nil,font: UIFont? = nil) {
        if let labelText = self.text {
            guard labelText.count > 0 else { return }
            if labelText.contains(text) {
                let range = labelText.rangeOfString(str: text)
                
                let c = color ?? self.textColor
                let f = font ?? self.font
                
                let attr = NSMutableAttributedString(string: labelText)
                attr.addAttributes([NSAttributedString.Key.foregroundColor: c!, NSAttributedString.Key.font: f!], range: range)
                self.attributedText = attr
            }
        }
    }
    // 同一段文案 多个部分色值、字体变化
    public func attributeTexts(text: String ..., color: UIColor? = nil,font: UIFont? = nil) {
        if let labelText = self.text {
            let attr = NSMutableAttributedString(string: labelText)
            // 中间变量 可变 text, 解决当传入的text有相同元素的时候，定位Range
            var mutiText = labelText
            
            for t in text {
                if labelText.contains(t) {
                    let range = mutiText.rangeOfString(str: t)
                    
                    // mutiText
                    var repalceStr = ""
                    for _ in 0..<(range.length) {
                        repalceStr = repalceStr + "X"
                    }
                    mutiText = mutiText.replaceRange(inRange: range, withStr: repalceStr)
                    
                    let c = color ?? self.textColor
                    let f = font ?? self.font
                    
                    attr.addAttributes([NSAttributedString.Key.foregroundColor: c!, NSAttributedString.Key.font: f!], range: range)
                }
            }
            self.attributedText = attr
        }
    }
    
    // 同一段文案 多个部分色值、字体变化
    public func attributeTextsArr(textsArr: [String], color: UIColor? = nil,font: UIFont? = nil) {
        if let labelText = self.text {
            let attr = NSMutableAttributedString(string: labelText)
            // 中间变量 可变 text, 解决当传入的text有相同元素的时候，定位Range
            var mutiText = labelText
            
            for t in textsArr {
                if labelText.contains(t) {
                    let range = mutiText.rangeOfString(str: t)
                    
                    // mutiText
                    var repalceStr = ""
                    for _ in 0..<(range.length) {
                        repalceStr = repalceStr + "X"
                    }
                    mutiText = mutiText.replaceRange(inRange: range, withStr: repalceStr)
                    
                    let c = color ?? self.textColor
                    let f = font ?? self.font
                    
                    attr.addAttributes([NSAttributedString.Key.foregroundColor: c!, NSAttributedString.Key.font: f!], range: range)
                }
            }
            self.attributedText = attr
        }
    }
    
    public func newAttrbuteTexts(text: String ..., color: UIColor? = nil,font: UIFont? = nil) {
        let attr = NSMutableAttributedString(string: self.text!)
        // 中间变量 可变 text, 解决当传入的text有相同元素的时候，定位Range
        var mutiText = self.text!
        
        for t in text {
            if mutiText.contains(t) {
                let range = (mutiText as NSString).range(of: t)
                
                // mutiText
                var repalceStr = ""
                for _ in 0..<(range.length) {
                    repalceStr = repalceStr + "X"
                }
                mutiText = (mutiText as NSString).replacingCharacters(in: range, with: repalceStr)
                let c = color ?? self.textColor
                let f = font ?? self.font
                
                attr.addAttributes([NSAttributedString.Key.foregroundColor: c!, NSAttributedString.Key.font: f!], range: range)
            }
        }
        self.attributedText = attr
    }
}
