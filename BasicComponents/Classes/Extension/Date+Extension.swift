
import Foundation

let calendar = Calendar.current

extension Date {
    
    // 根据当前时间计算下一天，以 Date 格式返回
    public func nextDate() -> Date {
        let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: self)
        let nextDate = calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime) ?? Date()
        return nextDate
    }
    
    // 根据日期获取对应年、月、日
    public func getYearMonthDay() -> (String, String, String) {
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        let yearStr = String(format: "%d", components.year ?? 2020)
        let monthStr = String(format: "%d", components.month ?? 06)
        let dayStr = String(format: "%d", components.day ?? 18)
        return (yearStr, monthStr, dayStr)
    }
    
    // 日期转字符串
    public func getDateStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
