//
//  SCSiriWaveformView.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 2017/2/9.
//  Copyright © 2017年 xiAo_Ju. All rights reserved.
//

import UIKit

class SCSiriWaveformView: UIView {
    
    private var phase: CGFloat = 0
    /*
     * Tells the waveform to redraw itself using the given level (normalized value)
     */
    func update(with level:CGFloat) {
        phase += phaseShift
        amplitude = fmax(level, idleAmplitude)
        setNeedsDisplay()
    }
    
    /*
     * The total number of waves
     * Default: 5
     */
    var numberOfWaves = 5
    
    /*
     * Color to use when drawing the waves
     * Default: white
     */
    var waveColor = UIColor.white
    
    /*
     * Line width used for the proeminent wave
     * Default: 3.0f
     */
    var primaryWaveLineWidth: CGFloat = 3
    
    /*
     * Line width used for all secondary waves
     * Default: 1.0f
     */
    var secondaryWaveLineWidth: CGFloat = 1
    
    /*
     * The amplitude that is used when the incoming amplitude is near zero.
     * Setting a value greater 0 provides a more vivid visualization.
     * Default: 0.01
     */
    var idleAmplitude: CGFloat = 0.01
    
    /*
     * The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
     * Default: 1.5
     */
    var frequency: CGFloat = 1.5
    
    /*
     * The current amplitude
     * Default: 1
     */
    private(set) var amplitude: CGFloat = 1
    
    /*
     * The lines are joined stepwise, the more dense you draw, the more CPU power is used.
     * Default: 5
     */
    var density: CGFloat = 5
    
    /*
     * The phase shift that will be applied with each level setting
     * Change this to modify the animation speed or direction
     * Default: -0.15
     */
    var phaseShift: CGFloat = -0.15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Thanks to Raffael Hannemann https://github.com/raffael/SISinusWaveView
    
    override func draw(_ rect: CGRect) {
        // We draw multiple sinus waves, with equal phases but altered amplitudes, multiplied by a parable function.
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(bounds)
        backgroundColor?.set()
        context.fill(bounds)

        for i in 0 ..< numberOfWaves {
            
            let strokeLineWidth = (i == 0 ? primaryWaveLineWidth : secondaryWaveLineWidth)
            
            context.setLineWidth(strokeLineWidth)

            let halfHeight = bounds.height / 2.0
            let width = bounds.width
            let mid = width / 2.0
            
            let maxAmplitude = halfHeight - 2 * strokeLineWidth // 4 corresponds to twice the stroke width
            
            // Progress is a value between 1.0 and -0.5, determined by the current wave idx, which is used to alter the wave's amplitude.
            let progress = 1.0 - CGFloat(i) / CGFloat(numberOfWaves)
            let normedAmplitude = (1.5 * progress - (2 / CGFloat(numberOfWaves))) * amplitude
            
            let multiplier = min(1.0, (progress / 3.0 * 2.0) + (1.0 / 3.0))

            waveColor.withAlphaComponent(multiplier * waveColor.cgColor.alpha).set()

            for x in stride(from: 0.0, to: width + density, by: density) {
                // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
                let scaling = -pow(1 / mid * (x - mid), 2) + 1
                
                let y = scaling * maxAmplitude * normedAmplitude * sin(2 * .pi * (x / width) * frequency + phase) + halfHeight
                
                if x == 0 {
                    context.move(to: CGPoint(x: x, y: y))
                } else {
                    context.addLine(to: CGPoint(x: x, y: y))
                }
            }
            context.strokePath()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
