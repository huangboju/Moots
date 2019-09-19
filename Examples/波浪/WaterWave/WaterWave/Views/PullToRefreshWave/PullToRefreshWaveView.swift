//
//  PullToRefreshWaveView.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 2016/10/15.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

let MaxVariable: CGFloat = 1.6
let MinVariable: CGFloat = 1.0
let MinStepLength: CGFloat = 0.01
let MaxStepLength: CGFloat = 0.05

let KeyPathsContentOffset = "contentOffset"
let KeyPathsContentInset = "ContentInset"
let KeyPathsFrame = "frame"
let KeyPathsPanGestureRecognizerState = "panGestureRecognizer.state"

enum PullToRefreshWaveViewState {
    case stopped, animating, animatingToStopped
}

class PullToRefreshWaveView: UIView {

    var actionHandler: (() -> Void)?
    var topWaveColor = UIColor(white: 0.667, alpha: 1) { // default to be 0.667 white
        didSet {
            firstWaveLayer.fillColor = topWaveColor.cgColor
        }
    }
    var bottomWaveColor = UIColor.white { // default to be white color
        didSet {
            secondWaveLayer.fillColor = bottomWaveColor.cgColor
        }
    }
    
    private var displaylink: CADisplayLink?
    private lazy var firstWaveLayer: CAShapeLayer = {
        let firstWaveLayer = CAShapeLayer()
        firstWaveLayer.fillColor = UIColor.lightGray.cgColor
        return firstWaveLayer
    }()
    private lazy var secondWaveLayer: CAShapeLayer = {
        let secondWaveLayer = CAShapeLayer()
        secondWaveLayer.fillColor = UIColor.white.cgColor
        return secondWaveLayer
    }()
    private var scrollView: UIScrollView? {
        didSet {
            cycle = 2 * .pi / scrollView!.frame.width
        }
    }
    
    private var state: PullToRefreshWaveViewState?
    private lazy var times = 1
    
    private lazy var amplitude = MaxVariable
    private lazy var cycle: CGFloat = 0
    private lazy var speed: CGFloat = 0.4 / .pi
    private lazy var offsetX: CGFloat = 0
    private lazy var offsetY: CGFloat = 0
    private lazy var variable = MaxVariable
    private lazy var height: CGFloat = 0
    private lazy var increase = false
    
    private var originalContentInsetTop: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        displaylink = CADisplayLink(target: self, selector: #selector(displayLinkTric))
        displaylink?.frameInterval = 2
        displaylink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        displaylink?.isPaused = true

        topWaveColor = UIColor.lightGray
        bottomWaveColor = UIColor.white
        setupProperty()
    }
    
    func setupProperty() {
        speed = 0.4 / .pi
        times = 1
        amplitude = MaxVariable;
        variable = MaxVariable;
        increase = false
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if scrollView == nil {
            return
        }
        
        if keyPath == KeyPathsContentOffset {
            scrollViewDidChangeContentOffset()
        } else if keyPath == KeyPathsFrame {
            
        } else if keyPath == KeyPathsContentInset {
            if let top = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.uiEdgeInsetsValue.top {
                originalContentInsetTop = top
            }
        } else if keyPath == KeyPathsPanGestureRecognizerState {
            // [self scrollViewDidChangeContentOffset]
        }
    }
    
    func scrollViewDidChangeContentOffset() {
        if let scrollView = scrollView {
            let offset = -scrollView.contentOffset.y - scrollView.contentInset.top
            if offset < 0 {
                times = 0
            }
            
            times = Int(offset) / 10 + 1
            
            if offset == 0.00 && scrollView.isDecelerating {
                animatingStopWave()
            }
            if offset >= 0.00 && !scrollView.isDecelerating && state != .animating && scrollView.isTracking {
                startWave()
            }
        }
    }
    
    func animatingStopWave() {
        state = .stopped
        if let actionHandler = actionHandler {
            actionHandler()
        }
    }
    
    func startWave() {
        
        if !displaylink!.isPaused {
            firstWaveLayer.path = nil
            secondWaveLayer.path = nil
            firstWaveLayer.removeFromSuperlayer()
            secondWaveLayer.removeFromSuperlayer()
        }
        
        setupProperty()
        
        state = .animating
        layer.addSublayer(firstWaveLayer)
        layer.addSublayer(secondWaveLayer)
        displaylink?.isPaused = false
    }
    
    func stopWave() {
        state = .stopped
        displaylink?.isPaused = true
        firstWaveLayer.path = nil
        secondWaveLayer.path = nil
        firstWaveLayer.removeFromSuperlayer()
        secondWaveLayer.removeFromSuperlayer()
    }

    func invalidateWave() {
        displaylink?.invalidate()
    }
    
    func observe(scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: KeyPathsContentOffset, options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: KeyPathsPanGestureRecognizerState, options: .new, context: nil)
    }
    
    func removeObserver(scrollView: UIScrollView) {
        scrollView.removeObserver(self, forKeyPath: KeyPathsContentOffset)
        scrollView.removeObserver(self, forKeyPath: KeyPathsPanGestureRecognizerState)
    }

    @objc func displayLinkTric(displayLink: CADisplayLink) {
        configWaveAmplitude()
        configWaveOffset()
        
        configViewFrame()
        configFirstWaveLayerPath()
        configSecondWaveLayerPath()
    }
    
    func configWaveAmplitude() {
        if increase {
            variable += MinStepLength;
        } else {
            let minus = state == .animatingToStopped ? MaxStepLength : MinStepLength
            variable -= minus
            if variable <= 0.00 {
                stopWave()
            }
        }
        
        if variable <= MinVariable {
            increase = state != .animatingToStopped
        }
        
        if variable >= MaxVariable {
            increase = false
        }
        
        // self.amplitude = self.variable*self.times;
        if times >= 7 {
            times = 7
        }
        amplitude = variable * CGFloat(times)
        height = MaxVariable * CGFloat(times)
    }
    
    func configWaveOffset() {
        offsetX += speed
        offsetY =  currentHeight - amplitude
    }
    
    func configViewFrame() {
        let width = scrollView!.bounds.width
        frame = CGRect(x: 0, y: -currentHeight, width: width, height: currentHeight)
    }
    
    func configFirstWaveLayerPath() {
        let path = CGMutablePath()
        var y = offsetY
        path.move(to: CGPoint(x: 0, y: y))
        
        let waveWidth = scrollView!.frame.width
        for x in 0...Int(waveWidth) {
            y = amplitude * sin(cycle * CGFloat(x) + offsetX) + offsetY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        
        path.addLine(to: CGPoint(x: waveWidth, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.closeSubpath()
        
        firstWaveLayer.path = path
    }
    
    func configSecondWaveLayerPath() {
        let path = CGMutablePath()
        var y = offsetY
        path.move(to: CGPoint(x: 0, y: y))
        
        // in this moment, the cos line and sin line do not look good when combine them, so just let cos line go forward the quarter of the wave cycle
        let forawrd = .pi / cycle / 2  // also equal 2*M_PI/_cycle/4
        
        let waveWidth = scrollView!.frame.width
        for x in 0...Int(waveWidth) {
            y = amplitude * cos(cycle * CGFloat(x) + offsetX - forawrd) + offsetY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }

        path.addLine(to: CGPoint(x: waveWidth, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.closeSubpath()
        
        secondWaveLayer.path = path
    }
    
    var currentHeight: CGFloat {
        return scrollView == nil ? 0.0 : max(-originalContentInsetTop + 2 * height, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
