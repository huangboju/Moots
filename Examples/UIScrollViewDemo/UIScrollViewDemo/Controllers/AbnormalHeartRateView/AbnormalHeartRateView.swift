import UIKit

class AbnormalHeartRateView: UIView {
    
    // MARK: - Properties
    private let heartRateValue: Int
    private let messageText: String
    
    // MARK: - UI Components
    private let redDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(heartRate: Int, message: String = "异常心率") {
        self.heartRateValue = heartRate
        self.messageText = message
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // Configure message label
        messageLabel.text = "\(messageText) \(heartRateValue)"
        
        // Add subviews
        addSubview(redDotView)
        addSubview(messageBubbleView)
        messageBubbleView.addSubview(messageLabel)
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Red dot - top left
            redDotView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            redDotView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            redDotView.widthAnchor.constraint(equalToConstant: 12),
            redDotView.heightAnchor.constraint(equalToConstant: 12),
            
            // Message bubble
            messageBubbleView.leadingAnchor.constraint(equalTo: redDotView.trailingAnchor, constant: 12),
            messageBubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageBubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            messageBubbleView.heightAnchor.constraint(equalToConstant: 44),
            
            // Message label
            messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -16),
            messageLabel.centerYAnchor.constraint(equalTo: messageBubbleView.centerYAnchor)
        ])
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBubbleTail()
    }
    
    private func drawBubbleTail() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Calculate tail position (pointing from bubble to red dot)
        let dotCenterX: CGFloat = 20 + 6 // leading + radius
        let dotCenterY: CGFloat = 20 + 6 // top + radius
        let bubbleLeft: CGFloat = dotCenterX + 12 + 6 // dot trailing + spacing + tail width
        
        // Create tail path (triangle pointing left)
        let tailPath = UIBezierPath()
        tailPath.move(to: CGPoint(x: bubbleLeft, y: 26)) // Top point of tail
        tailPath.addLine(to: CGPoint(x: bubbleLeft - 8, y: 30)) // Left point (towards dot)
        tailPath.addLine(to: CGPoint(x: bubbleLeft, y: 34)) // Bottom point of tail
        tailPath.close()
        
        // Fill tail with bubble color
        context.setFillColor(UIColor(white: 0.2, alpha: 1.0).cgColor)
        context.addPath(tailPath.cgPath)
        context.fillPath()
    }
    
    // MARK: - Public Methods
    func updateHeartRate(_ newRate: Int) {
        messageLabel.text = "\(messageText) \(newRate)"
    }
}