//
//  SiriWaveLine.swift
//  SiriWave
//
//  Created by Alexander Shoshiashvili on 24.10.2019.
//

import UIKit

public class SiriWaveLine {
    
    let GRAPH_X: CGFloat = 25
    let AMPLITUDE_FACTOR: CGFloat = 0.8
    let SPEED_FACTOR: CGFloat = 1
    let DEAD_PX: CGFloat = 2
    let ATT_FACTOR: CGFloat = 4
    let DESPAWN_FACTOR: CGFloat = 0.02
    let NOOFCURVES_RANGES: [CGFloat] = [5, 5]
    let AMPLITUDE_RANGES: [CGFloat] = [0.3, 1]
    let OFFSET_RANGES: [CGFloat] = [-3, 3]
    let WIDTH_RANGES: [CGFloat] = [1, 3]
    let SPEED_RANGES: [CGFloat] = [0.5, 1]
    let DESPAWN_TIMEOUT_RANGES: [CGFloat] = [500, 2000]
    
    var spawnAt: Int = Date().millisecondsSince1970
    var noOfCurves: Int!
    var phases: [CGFloat] = []
    var offsets: [CGFloat] = []
    var speeds: [CGFloat] = []
    var finalAmplitudes: [CGFloat] = []
    var widths: [CGFloat] = []
    var amplitudes: [CGFloat] = []
    var despawnTimeouts: [CGFloat] = []
    var verses: [CGFloat] = []
    var prevMaxY: CGFloat = 0
    
    public private(set) var amplitude: CGFloat
    public private(set) var speed: CGFloat
    public private(set) var pixelDepth: CGFloat
    public private(set) var heightMax: CGFloat
    public private(set) var width: CGFloat
    public private(set) var color: UIColor
    
    public init(amplitude: CGFloat,
                speed: CGFloat,
                pixelDepth: CGFloat,
                width: CGFloat,
                heightMax: CGFloat,
                color: UIColor) {
        
        self.amplitude = amplitude
        self.speed = speed
        self.pixelDepth = pixelDepth
        self.width = width
        self.heightMax = heightMax
        self.color = color
        
        commonInit()
    }
    
    private func commonInit() {
        self.spawnAt = Date().millisecondsSince1970
        self.noOfCurves = Int(floor(getRandomRange(NOOFCURVES_RANGES)))
        
        self.phases = Array(repeating: 0.0, count: noOfCurves)
        self.offsets = Array(repeating: 0.0, count: noOfCurves)
        self.speeds = Array(repeating: 0.0, count: noOfCurves)
        self.finalAmplitudes = Array(repeating: 0.0, count: noOfCurves)
        self.widths = Array(repeating: 0.0, count: noOfCurves)
        self.amplitudes = Array(repeating: 0.0, count: noOfCurves)
        self.despawnTimeouts = Array(repeating: 0.0, count: noOfCurves)
        self.verses = Array(repeating: 0.0, count: noOfCurves)
        
        for ci in 0..<noOfCurves {
            self.respawnSingle(ci)
        }
    }
    
    public func drawLine(_ ctx: CGContext,
                         _ amplitude: CGFloat,
                         _ speed: CGFloat) {
        
        self.amplitude = amplitude
        self.speed = speed
        
        for ci in 0..<noOfCurves {
            if spawnAt + Int(despawnTimeouts[ci]) <= Date().millisecondsSince1970 {
                amplitudes[ci] -= DESPAWN_FACTOR;
            } else {
                amplitudes[ci] += DESPAWN_FACTOR;
            }
            
            amplitudes[ci] = min(max(amplitudes[ci], 0), finalAmplitudes[ci]);
            phases[ci] = (phases[ci] + speed * speeds[ci] * SPEED_FACTOR).truncatingRemainder(dividingBy: (2 * CGFloat.pi))
        }
        
        var maxY = -CGFloat.infinity
        var minX = CGFloat.infinity

        let inArray = [1, -1]
        for sign in inArray {

            ctx.beginPath()
            var i = -GRAPH_X
            while i <= GRAPH_X {

                let x = xpos(i)
                let y = ypos(i)
                let newY = heightMax/2 - CGFloat(sign) * y

                if x.isZero {
                    ctx.move(to: CGPoint(x: x,
                                         y: newY))
                } else {
                    ctx.addLine(to: CGPoint(x: x,
                                            y: newY))
                }

                minX = min(minX, x)
                maxY = max(maxY, y)

                i = i + pixelDepth
            }

            ctx.closePath()
            ctx.setFillColor(color.cgColor)
            ctx.setStrokeColor(color.cgColor)
            ctx.fillPath()
        }
        
        if (maxY < DEAD_PX && prevMaxY > maxY) {
            respawn()
        }
        
        prevMaxY = maxY
    }
    
    private func respawn() {
        commonInit()
    }
    private func respawnSingle(_ ci: Int) {
        self.phases[ci] = 0
        self.amplitudes[ci] = 0
        
        self.despawnTimeouts[ci] = getRandomRange(DESPAWN_TIMEOUT_RANGES)
        self.offsets[ci] = getRandomRange(OFFSET_RANGES)
        self.speeds[ci] = getRandomRange(SPEED_RANGES)
        self.finalAmplitudes[ci] = getRandomRange(AMPLITUDE_RANGES)
        self.widths[ci] = getRandomRange(WIDTH_RANGES)
        self.verses[ci] = getRandomRange([-1, 1])
    }
    private func yRelativePos(_ i: CGFloat) -> CGFloat {
        var y: CGFloat = 0
        
        for ci in 0..<noOfCurves {
            // Generate a static T so that each curve is distant from each oterh
            var t: CGFloat = 4.0 * (-1.0 + (CGFloat(ci) / (CGFloat(noOfCurves) - 1.0) * 2.0))
            // but add a dynamic offset
            t = t + offsets[ci]
            
            let k = 1 / widths[ci]
            let x = (i * k) - t
            
            let sin = sinus(verses[ci] * x, phases[ci])
            let attFn = globalAttFn(x)
            
            
            y = y + abs(amplitudes[ci] * sin * attFn)
        }
        
        // Divide for NoOfCurves so that y <= 1
        return (y / CGFloat(noOfCurves))
    }
    private func ypos(_ i: CGFloat) -> CGFloat {
        return AMPLITUDE_FACTOR *
            heightMax *
            amplitude *
            yRelativePos(i) *
            globalAttFn(i / GRAPH_X * 2)
    }
    private func xpos(_ i: CGFloat) -> CGFloat {
        return width * ((i + GRAPH_X) / (GRAPH_X * 2))
    }
    
    private func getRandomRange(_ e: [CGFloat]) -> CGFloat {
        return e[0] + (CGFloat.random(in: 0 ..< 1) * (e[1] - e[0]))
    }
    private func globalAttFn(_ x: CGFloat) -> CGFloat {
        return pow((ATT_FACTOR) / (ATT_FACTOR + pow(x, 2)),
                   ATT_FACTOR)
    }
    private func sinus(_ x: CGFloat, _ phase: CGFloat) -> CGFloat {
        return sin(x - phase)
    }
    
}
