
import Foundation

public extension Float {
    
    /// 绝对值
    func common_abs () -> Float {
        return fabsf(self)
    }
    
    /// 开方
    func common_sqrt () -> Float {
        return sqrtf(self)
    }
    
    /// 向下取整
    func common_floor () -> Float {
        return floorf(self)
    }
    
    /// 向上取整
    func common_ceil () -> Float {
        return ceilf(self)
    }
    
    /// 四舍五入
    func common_round () -> Float {
        return roundf(self)
    }
    
    /// 不超过最大值和最小值
    func common_clamp (min: Float, _ max: Float) -> Float {
        return Swift.max(min, Swift.min(max, self))
    }
    
    /// 最大值和最小值之间的随机值
    static func common_random(min: Float = 0, max: Float) -> Float {
        let diff = max - min;
        let rand = Float(arc4random() % (UInt32(RAND_MAX) + 1))
        return ((rand / Float(RAND_MAX)) * diff) + min;
    }
    
}

public extension CGFloat {
    
    /// 向下取整
    func common_floor () -> CGFloat {
        return CGFloat(Float(self).common_floor())
    }
    
    /// 向上取整
    func common_ceil () -> CGFloat {
        return CGFloat(Float(self).common_ceil())
    }
    
    /// 四舍五入
    func common_round () -> CGFloat {
        return CGFloat(Float(self).common_round())
    }
}
