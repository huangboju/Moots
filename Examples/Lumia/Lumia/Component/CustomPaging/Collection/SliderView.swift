//
//  SliderView.swift
//  CustomPaging
//
//  Created by Ilya Lobanov on 27/08/2018.
//  Copyright © 2018 Ilya Lobanov. All rights reserved.
//

import UIKit

final class CPSliderView: UIView {

    var value: CGFloat {
        get {
            return CGFloat(slider.value)
        }
        set {
            slider.value = Float(newValue)
            updateValueLabel()
        }
    }
    
    var defaultValue: CGFloat? = nil

    var limits: ClosedRange<CGFloat> {
        get {
            return CGFloat(slider.minimumValue)...CGFloat(slider.maximumValue)
        }
        set {
            slider.minimumValue = Float(newValue.lowerBound)
            slider.maximumValue = Float(newValue.upperBound)
            updateLimitTitles()
        }
    }
    
    var title: String = "" {
        didSet {
            titleButton.setTitle(title, for: .normal)
        }
    }
    
    var minTitle: String? {
        didSet {
            updateLimitTitles()
        }
    }
    
    var maxTitle: String? {
        didSet {
            updateLimitTitles()
        }
    }
    
    var onChange: ((CGFloat) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private let slider = UISlider()
    private let titleButton = UIButton(type: .system)
    private let minLabel = UILabel()
    private let maxLabel = UILabel()
    private let valueLabel = UILabel()
    
    private func setupViews() {
        addSubview(slider)
        slider.addTarget(self, action: #selector(CPSliderView.handleSlider), for: .valueChanged)
        slider.thumbTintColor = .applicationTintColor
        slider.minimumTrackTintColor = .lightGray
        slider.maximumTrackTintColor = .lightGray
        
        addSubview(titleButton)
        titleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        titleButton.contentHorizontalAlignment = .left
        titleButton.tintColor = .black
        titleButton.addTarget(self, action: #selector(handleTitleButton), for: .touchUpInside)
        
        addSubview(minLabel)
        minLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        addSubview(maxLabel)
        maxLabel.textAlignment = .right
        maxLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        addSubview(valueLabel)
        valueLabel.textAlignment = .center
        valueLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        setupLayout()
        updateLimitTitles()
    }
    
    private func setupLayout() {
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        minLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        maxLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        minLabel.rightAnchor.constraint(equalTo: valueLabel.leftAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: maxLabel.leftAnchor).isActive = true
        titleButton.bottomAnchor.constraint(equalTo: slider.topAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: maxLabel.topAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: minLabel.topAnchor).isActive = true
    }
    
    private func updateValueLabel() {
        valueLabel.text = value.stringDescription
    }
    
    private func updateLimitTitles() {
        minLabel.text = minTitle ?? limits.lowerBound.stringDescription
        maxLabel.text = maxTitle ??  limits.upperBound.stringDescription
    }
    
    @objc private func handleSlider() {
        updateValueLabel()
        onChange?(value)
    }
    
    @objc private func handleTitleButton() {
        if let v = defaultValue {
            value = v
        }
    }
    
}

private extension CGFloat {
    
    var stringDescription: String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter.string(from: NSNumber(value: Double(self))) ?? "\(self)"
    }
    
}
