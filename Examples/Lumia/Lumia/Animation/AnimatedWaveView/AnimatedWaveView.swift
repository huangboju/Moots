//
//  AnimatedWaveView.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit
import CoreMotion

struct PathBuilder {
    
    static func buildStar() -> UIBezierPath {
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 12.5, y: 0))
        starPath.addLine(to: CGPoint(x: 14.82, y: 5.37))
        starPath.addLine(to: CGPoint(x: 19.85, y: 2.39))
        starPath.addLine(to: CGPoint(x: 18.57, y: 8.09))
        starPath.addLine(to: CGPoint(x: 24.39, y: 8.64))
        starPath.addLine(to: CGPoint(x: 20, y: 12.5))
        starPath.addLine(to: CGPoint(x: 24.39, y: 16.36))
        starPath.addLine(to: CGPoint(x: 18.57, y: 16.91))
        starPath.addLine(to: CGPoint(x: 19.85, y: 22.61))
        starPath.addLine(to: CGPoint(x: 14.82, y: 19.63))
        starPath.addLine(to: CGPoint(x: 12.5, y: 25))
        starPath.addLine(to: CGPoint(x: 10.18, y: 19.63))
        starPath.addLine(to: CGPoint(x: 5.15, y: 22.61))
        starPath.addLine(to: CGPoint(x: 6.43, y: 16.91))
        starPath.addLine(to: CGPoint(x: 0.61, y: 16.36))
        starPath.addLine(to: CGPoint(x: 5, y: 12.5))
        starPath.addLine(to: CGPoint(x: 0.61, y: 8.64))
        starPath.addLine(to: CGPoint(x: 6.43, y: 8.09))
        starPath.addLine(to: CGPoint(x: 5.15, y: 2.39))
        starPath.addLine(to: CGPoint(x: 10.18, y: 5.37))
        starPath.close()
        return starPath
    }
}

public class AnimatedWaveView: UIView {
    
    // MARK: - Attributes
    
    // 7px between each wave
    private let waveIntervals: CGFloat = 7
    
    // Timing ratio is 40 seconds for a diameter of 667
    private let timingRatio: CFTimeInterval = 40.0 / 667.0
    
    // Scale of the final path's bounds in terms of the view's bounds
    private let scaleFactor: CGFloat = 1.75
    
    // CAAnimation Key
    private let waveAnimationKey = "wave_animation_key"
    
    // Starting rect
    private let baseRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    
    // Animated radial gradient
    private var gradientLayer = RadialGradientLayer()
    
    // Parent maskLayer (contains all wave shapes)
    private var maskLayer = CALayer()
    
    // CMMotion
    private let motionManager = CMMotionManager()
    
    // Default gradient colors
    private var gradientColors: [UIColor] = [
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.80),
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.50),
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.20),
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.02),
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.02)
    ]
    
    // Cached initial and final paths for the waves
    private let initialPath: UIBezierPath = PathBuilder.buildStar()
    private var finalPath: UIBezierPath = PathBuilder.buildStar()
    
    // Update the final path if a frame change is detected
    public override var frame: CGRect {
        didSet {
            self.finalPath = calculateFinalPath()
        }
    }
    
    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.finalPath = calculateFinalPath()
        self.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(sender:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(sender:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func willEnterForeground(sender: Notification) {
        trackMotion()
    }
    
    @objc func didEnterBackground(sender: Notification) {
        motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Public methods
    
    public func makeWaves() {
        let waves = buildWaves()
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        waves.forEach({ maskLayer.addSublayer($0) })
        addGradientLayer(withMask: maskLayer)
        trackMotion()
    }
    
    public func setGradientColors(_ colors: [UIColor]) {
        self.gradientColors = colors
    }
    
    
    // MARK: - Device Motion
    
    private func trackMotion() {
        if motionManager.isDeviceMotionAvailable {
            // Set how often the motion call back will trigger (in seconds)
            motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
            let motionQueue = OperationQueue()
            motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { [weak self] (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else { return }
                // Move the gradient to a new position
                self?.moveGradient(gravityX: data.gravity.x, gravityY: data.gravity.y)
            })
        }
    }
    
    // MARK: - Gradient
    
    private func addGradientLayer(withMask maskLayer: CALayer) {
        let colors = gradientColors.map({ $0.cgColor })
        gradientLayer = RadialGradientLayer(colors: colors, center: self.center)
        gradientLayer.mask = maskLayer
        gradientLayer.frame = self.frame
        gradientLayer.bounds = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    private func moveGradient(gravityX: Double, gravityY: Double) {
        DispatchQueue.main.async {
            // Use gravity as a percentage of the view's vertical/horizonal bounds to calculate new x & y
            let x = (CGFloat(gravityX + 1) * self.bounds.width) / 2
            let y = (CGFloat(-gravityY + 1) * self.bounds.height) / 2
            // Update gradient center position
            self.gradientLayer.center = CGPoint(x: x, y: y)
            self.gradientLayer.setNeedsDisplay()
        }
    }
    
    // MARK: - Waves
    
    private func buildScaleTransform() -> CGAffineTransform {
        // Grab initial and final shape diameter
        let initialDiameter = self.initialPath.bounds.height
        let finalDiameter = self.frame.height
        // Calculate the factor by which to scale the shape.
        let transformScaleFactor = finalDiameter / initialDiameter * scaleFactor
        // Build the transform
        return CGAffineTransform(scaleX: transformScaleFactor, y: transformScaleFactor)
    }
    
    private func calculateFinalPath() -> UIBezierPath {
        let path = PathBuilder.buildStar()
        let scaleTransform = buildScaleTransform()
        path.apply(scaleTransform)
        return path
    }
    
    private func buildWaves() -> [CAShapeLayer] {
        // Get the greater value of width or height
        let diameter = self.bounds.width > self.bounds.height ? self.bounds.width : self.bounds.height
        
        // Calculate radus substracting the initial starting rect
        let radius = (diameter - baseRect.width) / 2
        
        // Divide radius up by each wave
        let numberOfWaves = Int(radius / waveIntervals)
        
        // Duration needs to change based on diameter so that the animation speed is the same for any view size
        let animationDuration = timingRatio * Double(diameter)
        
        var waves: [CAShapeLayer] = []
        for i in 0 ..< numberOfWaves {
            let timeOffset = Double(i) * (animationDuration / Double(numberOfWaves))
            let wave = self.buildAnimatedWave(timeOffset: timeOffset, duration: animationDuration)
            waves.append(wave)
        }
        
        return waves
    }
    
    private func buildAnimatedWave(timeOffset: CFTimeInterval, duration: CFTimeInterval) -> CAShapeLayer {
        let waveLayer = self.buildWave(rect: baseRect, path: initialPath.cgPath)
        self.animateWave(waveLayer: waveLayer, duration: duration, offset: timeOffset)
        return waveLayer
    }
    
    private func buildWave(rect: CGRect, path: CGPath) -> CAShapeLayer {
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = self.center
        waveLayer.strokeColor = UIColor.black.cgColor
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.lineWidth = 2.0
        waveLayer.path = path
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }
    
    private func animateWave(waveLayer: CAShapeLayer, duration: CFTimeInterval, offset: CFTimeInterval) {
        // Fade-in animation
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 0.9
        fadeInAnimation.duration = 0.5
        
        // Path animation
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = waveLayer.path
        pathAnimation.toValue = finalPath.cgPath
        
        // Bounds animation
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        let scaleTransform = buildScaleTransform()
        boundsAnimation.fromValue = waveLayer.bounds
        boundsAnimation.toValue = waveLayer.bounds.applying(scaleTransform)
        
        // Animation Group
        let scaleWave = CAAnimationGroup()
        scaleWave.animations = [fadeInAnimation, boundsAnimation, pathAnimation]
        scaleWave.duration = duration
        scaleWave.isRemovedOnCompletion = false
        scaleWave.repeatCount = Float.infinity
        scaleWave.fillMode = .forwards
        scaleWave.timeOffset = offset
        waveLayer.add(scaleWave, forKey: waveAnimationKey)
    }
}
