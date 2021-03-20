
import UIKit

/*
 *  时间管理器
 */
public class TimerManager {
    
    /// 时间戳转成格式化字符串
    public class func timestampChangeToTimeStr(_ timeInterval: Double, dateFormat: String = "yyyy-MM-dd") -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    /// 时间戳转为天、时、分、秒
    public class func secondsTransformToTimeString(_ seconds: NSInteger) -> (String, String, String, String) {
        //天数计算
        let days = (seconds)/(24*3600);
        
        //小时计算
        let hours = (seconds)%(24*3600)/3600;
        
        //分钟计算
        let minutes = (seconds)%3600/60;
        
        //秒计算
        let second = (seconds)%60;
        
        let dayString = String(format: "%02lu", days)
        let hourString = String(format: "%02lu", hours)
        let minuteString = String(format: "%02lu", minutes)
        let secondString = String(format: "%02lu", second)
        
        return (dayString, hourString, minuteString, secondString)
    }
}

/*
 *  定时器
 */
public class CommonTimer: NSObject {
    
    private var timer: Timer!
    public var timerFiredBlock: ((Any?)->Void)?
    
    public class func scheduledTimer(timeInterval: TimeInterval, userInfo: Any?, repeats: Bool,  actionBlock:@escaping ((Any?)->Void)) -> CommonTimer {
        let timer = CommonTimer()
        timer.timerFiredBlock = actionBlock
        
        timer.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: timer, selector: #selector(timerFired(timer:)), userInfo: userInfo, repeats: repeats)
        return timer
    }
    
    @objc func timerFired(timer: Timer) {
        timerFiredBlock?(timer.userInfo)
    }
    
    /// 销毁定时器
    public func invalidate() {
        if let _ = timer {
            timer.invalidate()
            timer = nil
        }
        timerFiredBlock = nil
    }
    
    /// 暂停定时器
    public func pauseTimer() {
        timer.pauseTimer()
    }
    
    /// 重启定时器
    public func resumeTimer() {
        timer.resumeTimer()
    }
    
    /// 一段时间后重启定时器
    public func resumeTimerAfterTimeIntarval(timeIntarval: TimeInterval) {
        timer.resumeTimerAfterTimeIntarval(timeIntarval: timeIntarval)
    }
    
    deinit {
        debugPrint("CommonTimer---------deinit")
    }
}


public extension Timer {
    //  定时器暂停
    func pauseTimer() {
        guard self.isValid else { return }
        self.fireDate = Date.distantFuture
    }
    
    //  定时器重启
    func resumeTimer() {
        guard self.isValid else { return }
        self.fireDate = Date.distantPast
    }
    
    //  一段时间之后重启定时器
    func resumeTimerAfterTimeIntarval(timeIntarval: TimeInterval) {
        guard self.isValid else { return }
        self.fireDate = Date(timeIntervalSinceNow: timeIntarval)
    }
}
