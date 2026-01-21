import UIKit

class HeartRateIntervalChartView: UIView {
    
    // MARK: - Properties
    private var currentHeartRateData: [CGFloat] = []
    private var benchmarkHeartRateData: [CGFloat] = []
    private var xAxisLabels: [String] = ["2", "3", "4", "5", "6"]
    private var xAxisUnit: String = "公里"
    
    // MARK: - UI Components
    private let chartContainerView = UIView()
    private let gridLayer = CAShapeLayer()
    private let dataLayer = CAShapeLayer()
    private let xAxisLabelStackView = UIStackView()
    private let legendStackView = UIStackView()
    
    // MARK: - Constants
    private let gridLineCount = 4
    private let padding: CGFloat = 40
    private let bottomPadding: CGFloat = 60
    private let topPadding: CGFloat = 20
    private let leftPadding: CGFloat = 50
    private let rightPadding: CGFloat = 20
    
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
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Setup chart container
        chartContainerView.backgroundColor = .clear
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartContainerView)
        
        // Setup layers
        gridLayer.strokeColor = UIColor(white: 0.3, alpha: 1.0).cgColor
        gridLayer.lineWidth = 1.0
        gridLayer.lineDashPattern = [5, 5]
        gridLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(gridLayer)
        
        dataLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(dataLayer)
        
        // Setup X-axis labels
        setupXAxisLabels()
        
        // Setup legend
        setupLegend()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chartContainerView.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            chartContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            chartContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightPadding),
            chartContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
        ])
    }
    
    private func setupXAxisLabels() {
        xAxisLabelStackView.axis = .horizontal
        xAxisLabelStackView.distribution = .equalSpacing
        xAxisLabelStackView.alignment = .center
        xAxisLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(xAxisLabelStackView)
        
        // Add unit label
        let unitLabel = UILabel()
        unitLabel.text = xAxisUnit
        unitLabel.textColor = .lightGray
        unitLabel.font = .systemFont(ofSize: 12)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(unitLabel)
        
        // Add number labels
        for labelText in xAxisLabels {
            let label = UILabel()
            label.text = labelText
            label.textColor = .lightGray
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .center
            xAxisLabelStackView.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            xAxisLabelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            xAxisLabelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightPadding),
            xAxisLabelStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            unitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding - 30),
            unitLabel.centerYAnchor.constraint(equalTo: xAxisLabelStackView.centerYAnchor)
        ])
    }
    
    private func setupLegend() {
        legendStackView.axis = .horizontal
        legendStackView.spacing = 20
        legendStackView.alignment = .center
        legendStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(legendStackView)
        
        // Current heart rate interval (red)
        let currentLegend = createLegendItem(color: .red, text: "本次心率区间")
        legendStackView.addArrangedSubview(currentLegend)
        
        // Benchmark heart rate interval (gray)
        let benchmarkLegend = createLegendItem(color: .gray, text: "基准心率区间")
        legendStackView.addArrangedSubview(benchmarkLegend)
        
        NSLayoutConstraint.activate([
            legendStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            legendStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func createLegendItem(color: UIColor, text: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let colorView = UIView()
        colorView.backgroundColor = color
        colorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(colorView)
        
        let label = UILabel()
        label.text = text
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            colorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 12),
            colorView.heightAnchor.constraint(equalToConstant: 12),
            
            label.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        return containerView
    }
    
    // MARK: - Drawing
    override func layoutSubviews() {
        super.layoutSubviews()
        drawGrid()
        drawData()
    }
    
    private func drawGrid() {
        let chartWidth = chartContainerView.bounds.width
        let chartHeight = chartContainerView.bounds.height
        
        guard chartWidth > 0 && chartHeight > 0 else { return }

        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false
        format.scale = UIScreen.main.scale

        let renderer = UIGraphicsImageRenderer(size: chartContainerView.bounds.size, format: format)
        let image = renderer.image { rendererContext in
            let ctx = rendererContext.cgContext

            ctx.setLineWidth(gridLayer.lineWidth)
            ctx.setStrokeColor((gridLayer.strokeColor ?? UIColor(white: 0.3, alpha: 1.0).cgColor))

            if let dashPattern = gridLayer.lineDashPattern, !dashPattern.isEmpty {
                let lengths = dashPattern.map { CGFloat(truncating: $0) }
                ctx.setLineDash(phase: 0, lengths: lengths)
            } else {
                ctx.setLineDash(phase: 0, lengths: [])
            }

            // Draw horizontal grid lines
            for i in 0..<gridLineCount {
                let y = chartHeight * CGFloat(i) / CGFloat(gridLineCount - 1)
                ctx.move(to: CGPoint(x: 0, y: y))
                ctx.addLine(to: CGPoint(x: chartWidth, y: y))
            }

            ctx.strokePath()
        }

        // Use CGContext-rendered image instead of a path-based CAShapeLayer
        gridLayer.path = nil
        gridLayer.contentsScale = UIScreen.main.scale
        gridLayer.contents = image.cgImage
        gridLayer.frame = chartContainerView.frame
    }
    
    private func drawData() {
        guard !currentHeartRateData.isEmpty || !benchmarkHeartRateData.isEmpty else {
            return
        }
        
        let chartWidth = chartContainerView.bounds.width
        let chartHeight = chartContainerView.bounds.height
        
        guard chartWidth > 0 && chartHeight > 0 else { return }
        
        // Clear previous data
        dataLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // Draw benchmark data (gray)
        if !benchmarkHeartRateData.isEmpty {
            drawDataLine(data: benchmarkHeartRateData, color: .gray, chartWidth: chartWidth, chartHeight: chartHeight)
        }
        
        // Draw current data (red)
        if !currentHeartRateData.isEmpty {
            drawDataLine(data: currentHeartRateData, color: .red, chartWidth: chartWidth, chartHeight: chartHeight)
        }
    }
    
    private func drawDataLine(data: [CGFloat], color: UIColor, chartWidth: CGFloat, chartHeight: CGFloat) {
        guard data.count == xAxisLabels.count else { return }
        
        let maxValue = data.max() ?? 1.0
        let minValue = data.min() ?? 0.0
        let valueRange = maxValue - minValue
        let normalizedRange = valueRange > 0 ? valueRange : 1.0
        
        let path = UIBezierPath()
        let pointSpacing = chartWidth / CGFloat(xAxisLabels.count - 1)
        
        for (index, value) in data.enumerated() {
            let x = CGFloat(index) * pointSpacing
            let normalizedValue = (value - minValue) / normalizedRange
            let y = chartHeight * (1.0 - normalizedValue)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = color.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = 2.0
        lineLayer.frame = chartContainerView.frame
        dataLayer.addSublayer(lineLayer)
    }
    
    // MARK: - Public Methods
    func setCurrentHeartRateData(_ data: [CGFloat]) {
        currentHeartRateData = data
        setNeedsLayout()
    }
    
    func setBenchmarkHeartRateData(_ data: [CGFloat]) {
        benchmarkHeartRateData = data
        setNeedsLayout()
    }
    
    func setXAxisLabels(_ labels: [String]) {
        xAxisLabels = labels
        // Update labels in stack view
        xAxisLabelStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for labelText in xAxisLabels {
            let label = UILabel()
            label.text = labelText
            label.textColor = .lightGray
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .center
            xAxisLabelStackView.addArrangedSubview(label)
        }
        setNeedsLayout()
    }
}
