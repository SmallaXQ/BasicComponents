
import Foundation

extension NSObject {
    
    public func readableClassName() -> String {
        return type(of: self).readableClassName()
    }
    
    public class func readableClassName() -> String {
        let classString = NSStringFromClass(self)
        let range = classString.range(of: ".", options: .caseInsensitive, range: classString.startIndex..<classString.endIndex, locale: nil)
        return range.map{ String(classString.suffix(from: $0.upperBound)) } ?? classString
    }
}
