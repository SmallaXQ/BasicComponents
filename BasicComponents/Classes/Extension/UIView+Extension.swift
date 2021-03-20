
import UIKit
import Toast

extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.width, height: self.height)
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.width, height: self.height)
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.height)
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.width, height: value)
        }
    }
    
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }
    
    public var right: CGFloat {
        get {
            return self.x + self.width
        } set(value) {
            self.x = value - self.width
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.height
        } set(value) {
            self.y = value - self.height
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    /// View的中心X值
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    /// View的中心Y值
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
    public func toast(string: String, position:String = CSToastPositionCenter ) {
        self.makeToast(string, duration: 2, position: position)
    }
}

// MARK: Corner
extension UIView {
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    /// Corner radius of view
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
        }
    }
    
    public static var defaultReusableId: String {
        let arr = self.description().components(separatedBy: ".")
        if arr.count > 1 {
            return arr.dropFirst().joined(separator: ".")
        } else if arr.count == 1 {
            return arr.first ?? ""
        } else {
            assertionFailure("类型转字符串失败")
            return ""
        }
    }
    
    /// 部分圆角
    /* 使用
     
     // 调用没有任何问题，将左上角与右上角设为圆角。
     button.corner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 5)
     
     // 编译错误
     let corners: UIRectCorner = [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
     button.corner(byRoundingCorners: corners, radii: 5)
     */
    public func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    public func clipAllCorner(_ radii: CGFloat) {
        corner(byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight, UIRectCorner.topLeft, UIRectCorner.topRight], radii: radii)
    }
    
    // 播放动画，是否选中的图标改变时使用
    public func playAnimate() {
        // 图标先缩小，再放大
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4) {
                self.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
}

// MARK: SubView
extension UIView {
    public func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

/// Gesture
var blockActionDict : [String : ( () -> () )] = [:]
public extension UIView{
    
    /// 返回所在控制器
    func viewController() -> UIViewController? {
        var next = self.next
        while((next) != nil){
            if(next!.isKind(of: UIViewController.self)){
                let rootVc = next as! UIViewController
                return rootVc
            }
            next = next?.next
        }
        return nil
    }
    
    /// view以及其子类的block点击方法
    func tapActionsGesture(action:@escaping ( () -> Void )){
        addBlock(block: action)//添加点击block
        whenTouchOne()//点击block
    }
    
    /// 创建唯一标示  方便在点击的时候取出
    private func addBlock(block:@escaping ()->()){
        blockActionDict[String(self.hashValue)] = block
    }
    
    private func whenTouchOne(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(tapActions))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapActions(){
        blockActionDict[String(self.hashValue)]!()
    }
}

// MARK: - Animatoir (Basic)
public extension UIView {
    
    class Animator {
        public typealias AnimationsBlock = () -> Void
        public typealias CompletionBlock = (Bool) -> Void
        
        fileprivate var _animations: AnimationsBlock
        fileprivate var _completion: CompletionBlock?
        fileprivate var _duration: TimeInterval
        fileprivate var _delay: TimeInterval
        fileprivate var _options: UIView.AnimationOptions
        
        public init(
            duration: TimeInterval,
            delay: TimeInterval = 0.0,
            options: UIView.AnimationOptions = []) {
            
            _duration = duration
            _delay = delay
            _options = options
            _animations = {}
            _completion = nil
        }
        
        public func delay(_ delay: TimeInterval) -> Self {
            _delay = delay
            return self
        }
        
        public func options(_ options: UIView.AnimationOptions) -> Self {
            _options = options
            return self
        }
        
        public func animations(_ animations: @escaping AnimationsBlock) -> Self {
            _animations = animations
            return self
        }
        
        public func completion(_ completion: @escaping CompletionBlock) -> Self {
            _completion = completion
            return self
        }
        
        public func animate() {
            UIView.animate(
                withDuration: _duration,
                delay: _delay,
                options: _options,
                animations: _animations,
                completion: _completion)
        }
    }
}


// MARK: - SpringAnimator
public extension UIView {
    
    class SpringAnimator: Animator {
        fileprivate var _damping: CGFloat
        fileprivate var _velocity: CGFloat
        
        public init(
            duration: TimeInterval,
            delay: TimeInterval = 0.0,
            damping: CGFloat = 0.1,
            velocity: CGFloat = 0.1,
            options: UIView.AnimationOptions = []) {
            
            _damping = damping
            _velocity = velocity
            
            super.init(duration: duration, delay: delay, options: options)
        }
        
        public func damping(_ damping: CGFloat) -> Self {
            _damping = damping
            return self
        }
        
        public func velocity(_ velocity: CGFloat) -> Self {
            _velocity = velocity
            return self
        }
        
        public override func animate() {
            UIView.animate(
                withDuration: _duration,
                delay: _delay,
                usingSpringWithDamping: _damping,
                initialSpringVelocity: _velocity,
                options: _options,
                animations: _animations,
                completion: _completion)
        }
    }
}
