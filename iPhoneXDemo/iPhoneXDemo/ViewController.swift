//
//  ViewController.swift
//  iPhoneXDemo
//
//  Created by cyrill on 2018/1/3.
//  Copyright © 2018年 cyrill.win. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var vv: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gradientColors = [
            UIColor(hexString:"#4cd964").cgColor,
            UIColor(hexString:"#5ac8fa").cgColor,
            UIColor(hexString:"#007aff").cgColor,
            UIColor(hexString:"#34aadc").cgColor,
            UIColor(hexString:"#5856d6").cgColor,
            UIColor(hexString:"#ff2d55").cgColor
        ]
        
        
        let durations = Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)
        vv = GradientView(animationDurations: durations, gradientColors: gradientColors)
        vv.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
        self.view.addSubview(vv)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        vv.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class GradientView: UIView {
    
    /// Animation-Keys for each animation
    enum animationKeys: String {
        case fadeIn
        case fadeOut
        case progress
    }
    
    /// `CALayer` holding the gradient.
    let gradientLayer = CAGradientLayer()
    
    /// Configuration with durations for each animation.
    let animationDurations: Durations
    
    /// Colors used for the gradient.
    let gradientColors: [CGColor]
    
    
    
    init(animationDurations: Durations, gradientColors: [CGColor]) {
        self.animationDurations = animationDurations
        self.gradientColors = gradientColors
        
        super.init(frame: .zero)
        
        setupGradientLayer()
    }
    
    func setupGradientLayer() {
    
        var reversedColors = Array(gradientColors.reversed())
        reversedColors.removeFirst()
        reversedColors.removeLast()
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.purple.cgColor
        maskLayer.lineWidth = 10
        maskLayer.lineCap = kCALineCapRound
        maskLayer.path = self.path().cgPath
        self.layer.mask = maskLayer
        
        gradientLayer.opacity = 0.0
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = gradientColors + reversedColors + gradientColors
        self.layer.addSublayer(gradientLayer)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 3*bounds.size.width, height: bounds.size.height)
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.position    = CGPoint(x: 0, y: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Helper to toggle gradient layer visibility.
    private func updateGradientLayerVisibility(fromValue: CGFloat, toValue: CGFloat, duration: TimeInterval, animationKey: String) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        animation.duration = duration
        
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        gradientLayer.add(animation, forKey: animationKey)
    }
    
    /// Fades in gradient view
    public func show() {
        // Remove possible existing fade-out animation
        gradientLayer.removeAnimation(forKey: animationKeys.fadeOut.rawValue)
        
        updateGradientLayerVisibility(fromValue: 0.0,
                                      toValue: 1.0,
                                      duration: animationDurations.fadeIn,
                                      animationKey: animationKeys.fadeIn.rawValue)
    }
    
    /// Fades out gradient view
    public func hide() {
        // Remove possible existing fade-in animation
        gradientLayer.removeAnimation(forKey: animationKeys.fadeIn.rawValue)
        
        updateGradientLayerVisibility(fromValue: 1.0,
                                      toValue: 0.0,
                                      duration: animationDurations.fadeOut,
                                      animationKey: animationKeys.fadeOut.rawValue)
    }
    
    func startAnimation(layerParam: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        layerParam.add(animation, forKey: "ShapeLayerKey")
    }
    
    
    
    func path() -> UIBezierPath {
        let path = UIBezierPath()
        
        // 按顺序
        
        path.move(to: SCPoint(x: 0, y: 2))
        path.addLine(to: SCPoint(x: 234, y: 2))
        path.addCurve(to: SCPoint(x: 245.8, y: 15.4), controlPoint1: SCPoint(x: 241.8, y: 3.8), controlPoint2: SCPoint(x: 244.6, y: 7.4))
        
        path.addCurve(to: SCPoint(x: 818.0-508.0-8.4-53, y: 91-0.8-50.2), controlPoint1: SCPoint(x: 818.0-508.0-8.4-53-1.7, y: 91-0.8-50.2-16.4), controlPoint2: SCPoint(x: 246.3, y: 31.9))
        path.addCurve(to: SCPoint(x: 818.0-508.0-8.4, y: 91-0.8), controlPoint1: SCPoint(x: 818.0-508.0-8.4-45.2, y: 91-0.8-23.1), controlPoint2: SCPoint(x: 818.0-508.0-8.4-27.3, y: 91-0.8-6.5))
        
        path.addCurve(to: SCPoint(x: 818.0-508.0, y: 91), controlPoint1: SCPoint(x: 818.0-508.0-5.6, y: 91-0.2), controlPoint2: SCPoint(x: 818.0-508.0-2.7, y: 91-1.1))
        path.addCurve(to: SCPoint(x: 818.0, y: 91.0), controlPoint1: SCPoint(x: 818.0-338.7, y: 91), controlPoint2: SCPoint(x: 818.0-169.3, y: 91))
        
        
        // rrrr
        
        path.addCurve(to: SCPoint(x: 840.6, y: 85.9), controlPoint1:SCPoint(x: 825.7, y: 89.9) , controlPoint2: SCPoint(x: 833.3, y: 89.2))
        path.addCurve(to: SCPoint(x: 238.5+651+4.5-11.6-5, y: 2+16.2+29.7), controlPoint1: SCPoint(x: 858, y: 78), controlPoint2: SCPoint(x: 870, y: 65.4))
        path.addCurve(to: SCPoint(x: 238.5+651+4.5-11.6, y: 2+16.2), controlPoint1: SCPoint(x: 238.5+651+4.5-11.6-1, y: 2+16.2+20.1), controlPoint2: SCPoint(x: 238.5+651+4.5-11.6-0.1, y: 2+16.2+10.2))
        path.addCurve(to: SCPoint(x: 238.5+651+4.5-11.6, y: 2+16.2), controlPoint1: SCPoint(x: 238.5+651+4.5-8.7, y: 2+3), controlPoint2: SCPoint(x: 238.5+651+4.5-11.5, y: 2+6.9))
        path.addCurve(to: SCPoint(x: 238.5+651+4.5, y: 2), controlPoint1: SCPoint(x: 238.5+651+1.5, y: 1.1), controlPoint2: SCPoint(x: 238.5+651+3.4, y: 0))
        
        path.addLine(to: SCPoint(x: 1125, y: 2))
        
        
        // 原始路径
        
//        path.move(to: SCPoint(x: 0, y: 2))
//        path.addLine(to: SCPoint(x: 234, y: 2))
//        path.move(to: SCPoint(x: 818.0, y: 91.0))
//        path.addCurve(to: SCPoint(x: 818.0-508.0, y: 91), controlPoint1: SCPoint(x: 818.0-169.3, y: 91), controlPoint2: SCPoint(x: 818.0-338.7, y: 91))
//        path.addCurve(to: SCPoint(x: 818.0-508.0-8.4, y: 91-0.8), controlPoint1: SCPoint(x: 818.0-508.0-2.7, y: 91-1.1), controlPoint2: SCPoint(x: 818.0-508.0-5.6, y: 91-0.2))
//        path.addCurve(to: SCPoint(x: 818.0-508.0-8.4-53, y: 91-0.8-50.2), controlPoint1: SCPoint(x: 818.0-508.0-8.4-27.3, y: 91-0.8-6.5), controlPoint2: SCPoint(x: 818.0-508.0-8.4-45.2, y: 91-0.8-23.1))
//        path.addCurve(to: SCPoint(x: 245.8, y: 15.4), controlPoint1: SCPoint(x: 246.3, y: 31.9), controlPoint2: SCPoint(x: 818.0-508.0-8.4-53-1.7, y: 91-0.8-50.2-16.4))
//
//        path.addCurve(to: SCPoint(x: 234, y: 2), controlPoint1: SCPoint(x: 244.6, y: 7.4), controlPoint2: SCPoint(x: 241.8, y: 3.8))
//        path.addCurve(to: SCPoint(x: 234+0.5, y: 2-1), controlPoint1: SCPoint(x: 234+0.2, y: 2-0.3), controlPoint2: SCPoint(x: 234-0.5, y: 2-1))
//        path.addCurve(to: SCPoint(x: 234+0.5+4.0, y: 1), controlPoint1: SCPoint(x: 234+0.5+1.3, y: 1), controlPoint2: SCPoint(x: 234+0.5+2.7, y: 1))
//
//        path.addCurve(to: SCPoint(x: 238.5+651, y: 1.1), controlPoint1: SCPoint(x: 238.5+217, y: 1), controlPoint2: SCPoint(x: 238.5+434, y: 1))
//
//        path.addCurve(to: SCPoint(x: 238.5+651+4.5, y: 2), controlPoint1: SCPoint(x: 238.5+651+1.5, y: 1.1), controlPoint2: SCPoint(x: 238.5+651+3.4, y: 0))
//
//        path.addCurve(to: SCPoint(x: 238.5+651+4.5-11.6, y: 2+16.2), controlPoint1: SCPoint(x: 238.5+651+4.5-8.7, y: 2+3), controlPoint2: SCPoint(x: 238.5+651+4.5-11.5, y: 2+6.9))
//
//        path.addCurve(to: SCPoint(x: 238.5+651+4.5-11.6-5, y: 2+16.2+29.7), controlPoint1: SCPoint(x: 238.5+651+4.5-11.6-0.1, y: 2+16.2+10.2), controlPoint2: SCPoint(x: 238.5+651+4.5-11.6-1, y: 2+16.2+20.1))
//
//        path.addCurve(to: SCPoint(x: 840.6, y: 85.9), controlPoint1: SCPoint(x: 870, y: 65.4), controlPoint2: SCPoint(x: 858, y: 78))
//
//        path.addCurve(to: SCPoint(x: 818, y: 91), controlPoint1: SCPoint(x: 833.3, y: 89.2), controlPoint2: SCPoint(x: 825.7, y: 89.9))
//
//        path.move(to: SCPoint(x: 238.5+651+4.5, y: 2))
//        path.addLine(to: SCPoint(x: 1125, y: 2))


//        path.close()
        
        return path
    }
    
    fileprivate func SCPoint(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: x/3.0, y: y/3.0)
    }
}

extension GradientView: CAAnimationDelegate {
    
    public func animationDidStart(_ anim: CAAnimation) {
        guard anim == gradientLayer.animation(forKey: animationKeys.fadeIn.rawValue) else {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.fromValue = CGPoint(x: -2 * bounds.size.width, y: 0)
        animation.toValue = CGPoint(x: 0, y: 0)
        
        animation.duration = animationDurations.progress
        animation.repeatCount = Float.infinity
        
        gradientLayer.add(animation, forKey: animationKeys.progress.rawValue)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard anim == gradientLayer.animation(forKey: animationKeys.fadeOut.rawValue) else {
            return
        }
        
        gradientLayer.removeAnimation(forKey: animationKeys.progress.rawValue)
    }
}

extension UIColor {
    
    /// 便利初始化方法
    ///
    /// - Parameters:
    ///   - r: red
    ///   - g: green
    ///   - b: blue
    ///   - alpha: alpha
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 随机色 randomColor
    ///
    /// - Returns: UIColor
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    convenience init(hexString: String) {
        var normalizedHexString = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        if normalizedHexString.hasPrefix("#") {
            normalizedHexString.remove(at: normalizedHexString.startIndex)
        }
        
        let scanner = Scanner(string: normalizedHexString)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
}
