import UIKit

class AbnormalHeartRateViewVC: UIViewController {
    
    private var heartRateView: AbnormalHeartRateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // Create and add heart rate view
        heartRateView = AbnormalHeartRateView(heartRate: 165)
        heartRateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartRateView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            heartRateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heartRateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heartRateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heartRateView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
