//
//  UIViewExt.swift
//  GIViewKit
//
//  Created by Ray on 2018/12/26.
//  Copyright © 2018 Rex. All rights reserved.
//

//import BasicKit

/// Mark -

@IBDesignable open class LineView: UIView {
    
    open override func draw(_ rect: CGRect) {
//        super.draw(rect)
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: left, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width - right, y: bounds.height))
        
        UIColor.blue.setStroke()
//        UIColor.bk.blue(.view).setStroke()
        path.stroke()
    }
    
    
    /// 左边距
    private var left: CGFloat = 15
    @IBInspectable public var leading: CGFloat {
        set {
            left = newValue
        }
        get {
            return left
        }
    }
    
    
    
    /// 右边距
    private var right: CGFloat = 0
    @IBInspectable public var trailing: CGFloat {
        set {
            right = newValue
        }
        get {
            return left
        }
    }
    
}


/// mark -
@IBDesignable
extension UIView {
    
    private struct AssociatedKeys {
        static var dafaultCor = "dafaultCor"
        static var gradient = "gradient"
        static var gradientLayer = "gradientLayer"
        static var startColor = "startColor"
        static var endColor = "endColor"
    }
    
    
    /// 圆角
    @IBInspectable public var corner: CGFloat {
        set {
            if defaultCorner { return }
            resetCorner(newValue)
        }
        get { return layer.cornerRadius }
    }
    
    
    /// 默认圆角为2，如果为 `true` 会忽略 属性`corner`
    @IBInspectable public var defaultCorner: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dafaultCor, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                resetCorner(8)
            }
            clipsToBounds = newValue
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dafaultCor) as? Bool ?? false
        }
    }
    
    private func resetCorner(_ c: CGFloat) {
        layer.cornerRadius = c
    }
    
    
    @IBInspectable public var board_width: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth ?? 0
        }
    }
    
    @IBInspectable public var board_color: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            guard let c = layer.borderColor else { return .clear }
            return UIColor(cgColor: c)
        }
    }
}

//extension UIView {
//
//    @IBInspectable public var gradient: Bool {
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.gradient, newValue, .OBJC_ASSOCIATION_ASSIGN)
//        }
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.gradient) as? Bool ?? false
//        }
//    }
//
//    public var gradientLayer: CAGradientLayer {
//        get {
//            if let layer = objc_getAssociatedObject(self, &AssociatedKeys.gradientLayer) as? CAGradientLayer {
//                return layer
//            }
//
//            let layer = CAGradientLayer()
//            layer.frame = bounds
//
//            objc_setAssociatedObject(self, &AssociatedKeys.gradientLayer, layer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            return layer
//        }
//    }
//
//    @IBInspectable public var startColor: UIColor {
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.startColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.startColor) as? UIColor ?? (backgroundColor ?? UIColor.white)
//        }
//    }
//
//    @IBInspectable public var endColor: UIColor {
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.endColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.endColor) as? UIColor ?? (backgroundColor ?? UIColor.white)
//        }
//    }
//}



//extension BK where Base: UIView {
//    
//    /// 最上层的父视图
//    public var topSuper: UIView {
//        return BK.topSuper(self.base)
//    }
//    
//    
//    /// 最上层的父视图
//    ///
//    /// - Parameter view: 子视图
//    /// - Returns: 父视图
//    public static func topSuper(_ view: UIView) -> UIView {
//        guard let top = view.superview else { return view }
//        return self.topSuper(top)
//    }
//    
//    
//    /// 移除所有的子视图
//    public func removeAllSubviews() {
//        base.subviews.forEach { $0.removeFromSuperview() }
//    }
//}


import ReactiveCocoa
import ReactiveSwift


extension Reactive where Base: UIButton {
    
    public var eye: BindingTarget<Eyes>  {
        return makeBindingTarget { $0.eye = $1 }
    }
    
}




public enum Eyes {
    case visible, invisible
    static func toggle(_ eyes: Eyes) -> Eyes {
        switch eyes {
        case .visible:
            return .invisible
        case .invisible:
            return .visible
        }
    }
    mutating func toggle() {
        self = Eyes.toggle(self)
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var eyesOn = "eyesOn"
        static var eye = "eye"
        static var eyes = "eyes"
        static var eyeVisible = "eyeVisible"
        static var eyeInvisible = "eyeInvisible"
    }
    
    @IBInspectable var eyesOn: Bool {
        set {
            setTitle("", for: .normal)
            setTitle("", for: .selected)
            eye = .visible
            addTarget(self, action: #selector(changeEye), for: .touchUpInside)
        }
        get {
            return false
        }
    }
    
    @objc func changeEye() {
        self.eye? = Eyes.toggle(self.eye!)
    }
    public var eyes: MutableProperty<Eyes> {
        get {
            var v = objc_getAssociatedObject(self, &AssociatedKeys.eyes) as? MutableProperty<Eyes>
            if v != nil { return v! }
            v = MutableProperty(.visible)
            objc_setAssociatedObject(self, &AssociatedKeys.eyes, v, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return v!
        }
    }
    
    /// 目前状态
    public var eye: Eyes? {
        set {
            guard let newValue = newValue else { return }
            switch newValue {
            case .visible:
                setImage(eyeVisible, for: .normal)
            case .invisible:
                setImage(eyeInvisible, for: .normal)
            }
            eyes.swap(newValue)
            objc_setAssociatedObject(self, &AssociatedKeys.eye, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.eye) as? Eyes
        }
    }
    
    /// 可见
    @IBInspectable public var eyeVisible: UIImage? {
        set {
            setImage(newValue, for: .normal)
            objc_setAssociatedObject(self, &AssociatedKeys.eyeVisible, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.eyeVisible) as? UIImage
        }
    }
    
    /// 不可见
    @IBInspectable public var eyeInvisible: UIImage? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.eyeInvisible, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.eyeInvisible) as? UIImage
        }
    }
    
}


extension MutableProperty where Value == Eyes {
    
    // 是否可见
    public var isVisible: Signal<Bool, Never> {
        return self.signal.map { $0 == .visible }
    }
    
}

import ProgressHUD

extension Reactive where Base : UIViewController {
    
     var progressHud: BindingTarget<Bool> {
        makeBindingTarget { base, value in
            if value {
                ProgressHUD.animate(nil, .activityIndicator, interaction: false)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
}
