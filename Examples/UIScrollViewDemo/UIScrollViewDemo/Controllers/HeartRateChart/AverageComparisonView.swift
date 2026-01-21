import UIKit

class AverageComparisonView: UIView {
    
    // MARK: - Properties
    private let topAverageLabel = UILabel()
    private let bottomAverageLabel = UILabel()
    private let topDashedLine = CAShapeLayer()
    private let bottomDashedLine = CAShapeLayer()
    private let topGradientLayer = CAGradientLayer()
    private let bottomGradientLayer = CAGradientLayer()
    private let solidBar = UIView()
    
    var topAverage: Int = 169 {
        didSet {
            updateTopLabel()
        }
    }
    
    var bottomAverage: Int = 159 {
        didSet {
            updateBottomLabel()
        }
    }
    
    var currentValue: CGFloat = 0.5 {
        didSet {
            updateSolidBar()
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        
        setupLabels()
        setupDashedLines()
        setupSolidBar()
    }
    
    private func setupLabels() {
        // 顶部标签
        topAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        topAverageLabel.text = "平均 169"
        topAverageLabel.textColor = .systemRed
        topAverageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topAverageLabel.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        topAverageLabel.layer.cornerRadius = 6
        topAverageLabel.clipsToBounds = true
        topAverageLabel.textAlignment = .center
        topAverageLabel.padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        addSubview(topAverageLabel)
        
        // 底部标签
        bottomAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomAverageLabel.text = "平均 159"
        bottomAverageLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        bottomAverageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        bottomAverageLabel.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        bottomAverageLabel.layer.cornerRadius = 6
        bottomAverageLabel.clipsToBounds = true
        bottomAverageLabel.textAlignment = .center
        bottomAverageLabel.padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        addSubview(bottomAverageLabel)
        
        NSLayoutConstraint.activate([
            topAverageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topAverageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            bottomAverageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomAverageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func setupDashedLines() {
        // 顶部红色渐变虚线
        topGradientLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemRed.withAlphaComponent(0.3).cgColor
        ]
        topGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        topGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        topGradientLayer.mask = topDashedLine
        layer.addSublayer(topGradientLayer)
        
        topDashedLine.strokeColor = UIColor.white.cgColor
        topDashedLine.lineWidth = 1.5
        topDashedLine.lineDashPattern = [4, 4]
        topDashedLine.fillColor = UIColor.clear.cgColor
        
        // 底部灰色渐变虚线
        bottomGradientLayer.colors = [
            UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3).cgColor
        ]
        bottomGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        bottomGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        bottomGradientLayer.mask = bottomDashedLine
        layer.addSublayer(bottomGradientLayer)
        
        bottomDashedLine.strokeColor = UIColor.white.cgColor
        bottomDashedLine.lineWidth = 1.5
        bottomDashedLine.lineDashPattern = [4, 4]
        bottomDashedLine.fillColor = UIColor.clear.cgColor
    }
    
    private func updateDashedLines() {
        let lineY1 = topAverageLabel.frame.maxY + 20
        let lineY2 = bottomAverageLabel.frame.minY - 20
        
        // 顶部红色渐变虚线
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: 16, y: lineY1))
        topPath.addLine(to: CGPoint(x: bounds.width - 16, y: lineY1))
        topDashedLine.path = topPath.cgPath
        
        topGradientLayer.frame = CGRect(x: 16, y: lineY1 - 1, width: bounds.width - 32, height: 3)
        
        // 底部灰色渐变虚线
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: 16, y: lineY2))
        bottomPath.addLine(to: CGPoint(x: bounds.width - 16, y: lineY2))
        bottomDashedLine.path = bottomPath.cgPath
        
        bottomGradientLayer.frame = CGRect(x: 16, y: lineY2 - 1, width: bounds.width - 32, height: 3)
    }
    
    private func setupSolidBar() {
        solidBar.translatesAutoresizingMaskIntoConstraints = false
        solidBar.backgroundColor = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
        solidBar.layer.cornerRadius = 2
        addSubview(solidBar)
        
        NSLayoutConstraint.activate([
            solidBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            solidBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            solidBar.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updateDashedLines()
        updateSolidBar()
    }
    
    private func updateSolidBar() {
        let topLineY = topAverageLabel.frame.maxY + 20
        let bottomLineY = bottomAverageLabel.frame.minY - 20
        let centerY = (topLineY + bottomLineY) / 2
        
        solidBar.center = CGPoint(x: bounds.midX, y: centerY)
    }
    
    private func updateTopLabel() {
        topAverageLabel.text = "平均 \(topAverage)"
    }
    
    private func updateBottomLabel() {
        bottomAverageLabel.text = "平均 \(bottomAverage)"
    }
}

// MARK: - UILabel Extension for Padding
extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
