//
//  FitGradient.swift
//  FitGradient
//
//  Created by cyrill on 2017/12/30.
//  Copyright © 2017年 cyrill.win. All rights reserved.
//

import UIKit

class FitGradient {
    
    static let window_ = UIWindow()
    
    let gradientView: GradientView!
    
    init() {
        let statusH = UIApplication.shared.statusBarFrame.size.height
        let windowH = statusH
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: windowH)
        
        FitGradient.window_.isHidden = true
        FitGradient.window_.windowLevel = UIWindowLevelAlert
        FitGradient.window_.backgroundColor = .clear
        FitGradient.window_.frame = frame
        FitGradient.window_.rootViewController = UIViewController()
        FitGradient.window_.isHidden = false
        
        let gradientColors = [
            #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor,
            #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1).cgColor,
            #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor,
            #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).cgColor,
            #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor,
            #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        ]

        let durations = Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)
        gradientView = GradientView(animationDurations: durations, gradientColors: gradientColors)
        gradientView.frame = frame
        FitGradient.window_.addSubview(gradientView)
    }
    
    func show() {
        gradientView.show()
    }
    
    func hide() {
        gradientView.hide()
    }
}

class GradientView: UIView {
    
    /// Animation-Keys for each animation
    enum animationKeys: String {
        case fadeIn
        case fadeOut
        case progress
    }
    
    let gradientLayer = CAGradientLayer()
    let animationDurations: Durations
    let gradientColors: [CGColor]
    
    init(animationDurations: Durations, gradientColors: [CGColor]) {
        self.animationDurations = animationDurations
        self.gradientColors = gradientColors
        
        super.init(frame: .zero)
        
        setupGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.position = CGPoint(x: 0, y: 0)
        
    }
    
    // MARK: - private
    
    private func setupGradientLayer() {
        
        var reversedColors = Array(gradientColors.reversed())
        reversedColors.removeFirst()
        reversedColors.removeLast()
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.purple.cgColor
        maskLayer.lineWidth = 10
        maskLayer.lineCap = kCALineCapRound
        maskLayer.path = hairPath.path().cgPath
        self.layer.mask = maskLayer
        
        gradientLayer.opacity = 0.0
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = gradientColors + reversedColors + gradientColors
        self.layer.addSublayer(gradientLayer)
    }
    
    private func updateGradientLayer(fromValue: CGFloat, toValue: CGFloat, duration: TimeInterval, animationKey: String) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        animation.duration = duration
        
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        gradientLayer.add(animation, forKey: animationKey)
    }
    
    // MARK: - public
    
    public func show() {
        // Remove possible existing fade-out animation
        gradientLayer.removeAnimation(forKey: animationKeys.fadeOut.rawValue)
        
        updateGradientLayer(fromValue: 0.0,
                                      toValue: 1.0,
                                      duration: animationDurations.fadeIn,
                                      animationKey: animationKeys.fadeIn.rawValue)
    }
    
    /// Fades out gradient view
    public func hide() {
        // Remove possible existing fade-in animation
        gradientLayer.removeAnimation(forKey: animationKeys.fadeIn.rawValue)
        
        updateGradientLayer(fromValue: 1.0,
                                      toValue: 0.0,
                                      duration: animationDurations.fadeOut,
                                      animationKey: animationKeys.fadeOut.rawValue)
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

struct Durations {
    
    let fadeIn: Double
    let fadeOut: Double
    let progress: Double
    
    public init(fadeIn: Double = 0.0, fadeOut: Double = 0.0, progress: Double = 0.0) {
        self.fadeIn = fadeIn
        self.fadeOut = fadeOut
        self.progress = progress
    }
}

/// 刘海path
struct hairPath {
    
    static func path() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        // 按顺序
        // left
        path.move(to: SCPoint(x: 0, y: 2))
        path.addLine(to: SCPoint(x: 234, y: 2))
        path.addCurve(to: SCPoint(x: 245.8, y: 15.4), controlPoint1: SCPoint(x: 241.8, y: 3.8), controlPoint2: SCPoint(x: 244.6, y: 7.4))
        
        path.addCurve(to: SCPoint(x: 818.0-508.0-8.4-53, y: 91-0.8-50.2), controlPoint1: SCPoint(x: 818.0-508.0-8.4-53-1.7, y: 91-0.8-50.2-16.4), controlPoint2: SCPoint(x: 246.3, y: 31.9))
        path.addCurve(to: SCPoint(x: 818.0-508.0-8.4, y: 91-0.8), controlPoint1: SCPoint(x: 818.0-508.0-8.4-45.2, y: 91-0.8-23.1), controlPoint2: SCPoint(x: 818.0-508.0-8.4-27.3, y: 91-0.8-6.5))
        
        path.addCurve(to: SCPoint(x: 818.0-508.0, y: 91), controlPoint1: SCPoint(x: 818.0-508.0-5.6, y: 91-0.2), controlPoint2: SCPoint(x: 818.0-508.0-2.7, y: 91-1.1))
        path.addCurve(to: SCPoint(x: 818.0, y: 91.0), controlPoint1: SCPoint(x: 818.0-338.7, y: 91), controlPoint2: SCPoint(x: 818.0-169.3, y: 91))
        
        // right
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
//
//        path.close()
        
        return path
    }
    
    static func SCPoint(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: x/3.0, y: y/3.0)
    }
}
