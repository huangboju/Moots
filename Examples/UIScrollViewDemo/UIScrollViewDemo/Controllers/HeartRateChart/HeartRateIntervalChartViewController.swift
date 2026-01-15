import UIKit

class HeartRateIntervalChartViewController: UIViewController {
    
    private let chartView = HeartRateIntervalChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Example: Set sample data (you can remove this and set your own data)
        // chartView.setCurrentHeartRateData([120, 135, 140, 145, 150])
        // chartView.setBenchmarkHeartRateData([110, 125, 130, 135, 140])
    }
}
