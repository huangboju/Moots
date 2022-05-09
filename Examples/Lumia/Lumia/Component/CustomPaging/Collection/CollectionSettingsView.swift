//
//  CollectionSettingsView.swift
//  CustomPaging
//
//  Created by Ilya Lobanov on 27/08/2018.
//  Copyright © 2018 Ilya Lobanov. All rights reserved.
//

import UIKit

protocol CollectionSettingsViewDelegate: class {
    func didChangeDeceleration(_ value: CGFloat)
    func didChangeSpringBounciness(_ value: CGFloat)
    func didChangeSpringSpeed(_ value: CGFloat)
}

final class CollectionSettingsView: UIView {

    struct Default {
        static let decelerationRate: CGFloat = UIScrollView.DecelerationRate.normal.rawValue
        static let decelerationRateLimits = UIScrollView.DecelerationRate.fast.rawValue...UIScrollView.DecelerationRate.normal.rawValue
        
        static let springBounciness: CGFloat = 4
        static let springBouncinessLimits: ClosedRange<CGFloat> = 0.1...20
        
        static let springSpeed: CGFloat = 12
        static let springSpeedLimits: ClosedRange<CGFloat> = 0.1...20
    }
    
    weak var delegate: CollectionSettingsViewDelegate? = nil
    
    var decelerationRate: CGFloat {
        return decelerationSlider.value
    }
    
    var springBounciness: CGFloat {
        return springBouncinessSlider.value
    }
    
    var springSpeed: CGFloat {
        return springSpeedSlider.value
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
 
    private let decelerationSlider = CPSliderView()
    private let springBouncinessSlider = CPSliderView()
    private let springSpeedSlider = CPSliderView()
    private let stackView = UIStackView()
    
    private func setupViews() {
        addSubview(stackView)
        stackView.alignment = .fill
        stackView.axis = .vertical
    
        stackView.addArrangedSubview(decelerationSlider)
        decelerationSlider.title = "Deceleration Rate"
        decelerationSlider.limits = Default.decelerationRateLimits
        decelerationSlider.value = Default.decelerationRate
        decelerationSlider.defaultValue = Default.decelerationRate
        decelerationSlider.minTitle = "Fast"
        decelerationSlider.maxTitle = "Normal"
        decelerationSlider.onChange = { [weak self] value in
            self?.delegate?.didChangeDeceleration(value)
        }
        
        stackView.addArrangedSubview(springBouncinessSlider)
        springBouncinessSlider.title = "Spring Bounciness"
        springBouncinessSlider.limits = Default.springBouncinessLimits
        springBouncinessSlider.value = Default.springBounciness
        springBouncinessSlider.defaultValue = Default.springBounciness
        springBouncinessSlider.onChange = { [weak self] value in
            self?.delegate?.didChangeSpringBounciness(value)
        }
        
        stackView.addArrangedSubview(springSpeedSlider)
        springSpeedSlider.title = "Spring Speed"
        springSpeedSlider.limits = Default.springSpeedLimits
        springSpeedSlider.value = Default.springSpeed
        springSpeedSlider.defaultValue = Default.springSpeed
        springSpeedSlider.onChange = { [weak self] value in
            self?.delegate?.didChangeSpringSpeed(value)
        }
        
        setupLayout()
    }
    
    private func setupLayout() {
        let inset: CGFloat = 16
        
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
    }
 
}
