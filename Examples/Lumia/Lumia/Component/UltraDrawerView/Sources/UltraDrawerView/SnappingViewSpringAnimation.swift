import CoreGraphics


internal final class SnappingViewSpringAnimation: SnappingViewAnimation {
    
    init(
        initialOrigin: CGFloat,
        targetOrigin: CGFloat,
        initialVelocity: CGFloat,
        parameters: AnimationParameters,
        onUpdate: @escaping (CGFloat) -> Void,
        completion: @escaping (Bool) -> Void
    ) {
        self.currentOrigin = initialOrigin
        self.currentVelocity = initialVelocity
        self.targetOrigin = targetOrigin
        self.parameters = parameters
        self.threshold = 0.5
        self.onUpdate = onUpdate
        self.completion = completion
        
        updateAnimation()
    }
    
    func invalidate() {
        animation?.invalidate()
    }
    
    // MARK: - SnappingViewAnimation
    
    var targetOrigin: CGFloat {
        didSet {
            updateAnimation()
        }
    }
    
    var isDone: Bool {
        return animation?.running ?? false
    }
    
    // MARK: - Private
    
    private var currentOrigin: CGFloat
    private var currentVelocity: CGFloat
    private let parameters: AnimationParameters
    private let threshold: CGFloat
    private let onUpdate: (CGFloat) -> Void
    private let completion: (Bool) -> Void
    private var animation: UltraDrawerViewTimerAnimation?
    
    private func updateAnimation() {
        guard !isDone else { return }
        
        animation?.invalidate(withColmpletion: false)

        let to = targetOrigin
        let timingParameters = makeTimingParameters()
        
        animation = UltraDrawerViewTimerAnimation(
            animations: { [weak self, timingParameters, threshold] time in
                guard let self = self else {
                    return .finish
                }

                self.currentOrigin = to + timingParameters.value(at: time)
                self.onUpdate(self.currentOrigin)

                return timingParameters.amplitude(at: time) < threshold ? .finish : .continue
            },
            completion: { [onUpdate, completion] finished in
                if finished {
                    onUpdate(to)
                }
                completion(finished)
            }
        )
    }

    private func makeTimingParameters() -> DampingTimingParameters {
        let from = currentOrigin
        let to = targetOrigin

        switch parameters {
        case let .spring(spring):
            return UltraSpringTimingParameters(
                spring: spring,
                displacement: from - to,
                initialVelocity: currentVelocity,
                threshold: threshold
            )
        }
    }
}

public struct UltraSpringTimingParameters {
    public let spring: Spring
    public let displacement: CGFloat
    public let initialVelocity: CGFloat
    public let threshold: CGFloat
    private let impl: DampingTimingParameters
        
    public init(spring: Spring, displacement: CGFloat, initialVelocity: CGFloat, threshold: CGFloat) {
        self.spring = spring
        self.displacement = displacement
        self.initialVelocity = initialVelocity
        self.threshold = threshold
        
        if spring.dampingRatio == 1 {
            self.impl = CriticallyDampedSpringTimingParameters(
                spring: spring,
                displacement: displacement,
                initialVelocity: initialVelocity,
                threshold: threshold
            )
        } else if spring.dampingRatio > 0, spring.dampingRatio < 1 {
            self.impl = UnderdampedSpringTimingParameters(
                spring: spring,
                displacement: displacement,
                initialVelocity: initialVelocity,
                threshold: threshold
            )
        } else {
            fatalError("dampingRatio should be greater than 0 and less than or equal to 1")
        }
    }
}

extension UltraSpringTimingParameters: DampingTimingParameters {

    public var duration: TimeInterval {
        return impl.duration
    }
    
    public func value(at time: TimeInterval) -> CGFloat {
        return impl.value(at: time)
    }

    public func amplitude(at time: TimeInterval) -> CGFloat {
        return impl.amplitude(at: time)
    }
        
}

// MARK: - Private Impl
 
private struct UnderdampedSpringTimingParameters {
    let spring: Spring
    let displacement: CGFloat
    let initialVelocity: CGFloat
    let threshold: CGFloat
}

extension UnderdampedSpringTimingParameters: DampingTimingParameters {
    
    var duration: TimeInterval {
        if displacement == 0, initialVelocity == 0 {
            return 0
        }
        
        return TimeInterval(log((abs(c1) + abs(c2)) / threshold) / spring.beta)
    }
    
    func value(at time: TimeInterval) -> CGFloat {
        let t = CGFloat(time)
        let wd = spring.dampedNaturalFrequency
        return exp(-spring.beta * t) * (c1 * cos(wd * t) + c2 * sin(wd * t))
    }

    func amplitude(at time: TimeInterval) -> CGFloat {
        let t = CGFloat(time)
        return exp(-spring.beta * t) * (abs(c1) + abs(c2))
    }

    // MARK: - Private
    
    private var c1: CGFloat {
        return displacement
    }
    
    private var c2: CGFloat {
        return (initialVelocity + spring.beta * displacement) / spring.dampedNaturalFrequency
    }
    
}

private struct CriticallyDampedSpringTimingParameters {
    let spring: Spring
    let displacement: CGFloat
    let initialVelocity: CGFloat
    let threshold: CGFloat
}

extension CriticallyDampedSpringTimingParameters: DampingTimingParameters {
    
    var duration: TimeInterval {
        if displacement == 0, initialVelocity == 0 {
            return 0
        }
        
        let b = spring.beta
        let e = CGFloat(M_E)
         
        let t1 = 1 / b * log(2 * abs(c1) / threshold)
        let t2 = 2 / b * log(4 * abs(c2) / (e * b * threshold))
        
        return TimeInterval(max(t1, t2))
    }
    
    func value(at time: TimeInterval) -> CGFloat {
        let t = CGFloat(time)
        return exp(-spring.beta * t) * (c1 + c2 * t)
    }

    func amplitude(at time: TimeInterval) -> CGFloat {
        return abs(value(at: time))
    }

    // MARK: - Private
    
    private var c1: CGFloat {
        return displacement
    }
    
    private var c2: CGFloat {
        return initialVelocity + spring.beta * displacement
    }
    
}

