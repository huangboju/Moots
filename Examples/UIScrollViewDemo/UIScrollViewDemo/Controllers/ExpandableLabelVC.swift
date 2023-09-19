//
//  ExpandableLabelVC.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2023/9/19.
//  Copyright © 2023 伯驹 黄. All rights reserved.
//

import SnapKit


class ExpandableLabelVC: UITableViewController {

    var imageViews: [(CGRect, UIImageView)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Capture", style: .plain, target: self, action: #selector(captureClicked))

        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(150)
        }

        view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureClicked()
    }

    @objc func captureClicked() {
        let image = textLabel.makeScreenshot()
        let lines = textLabel.numberOfVisibleLines
        let size = image.size
        let height = size.height / CGFloat(lines)
        for line in 0 ..< lines {
            let rect = CGRect(x: 0, y: height * CGFloat(line), width: size.width, height: height)
            let subImage = image.crop(rect: rect)
            let imageView = UIImageView(image: subImage)
            imageView.alpha = line == 0 ? 1 : 0
            imageView.backgroundColor = .white
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(textLabel)
                make.top.equalTo(textLabel.snp.bottom).offset(20)
            }
            imageViews.append((rect, imageView))
        }
    }

    @objc
    func valueChanged(_ sender: UISlider) {
        if imageViews.isEmpty { return }
        let progress = CGFloat(sender.value)
        let baseline = imageViews[0].0.minY
        for (rect, imageView) in imageViews.dropFirst() {
            let distance = rect.minY - baseline
            let detal = distance * progress
            imageView.alpha = progress
            imageView.snp.updateConstraints { make in
                make.leading.trailing.equalTo(textLabel)
                make.top.equalTo(textLabel.snp.bottom).offset(20 + detal)
            }
        }
    }

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.text = "必要的信号分析与数据处理，从而获得与被测对象有关的信息必要的信号分析与数据处理，从而获得与被测对象有关的信息"
        return textLabel
    }()

    private lazy var slider: UISlider = {
        let height = self.view.frame.height
        let slider = UISlider(frame: CGRect(x: 0, y: height - 80, width: self.view.frame.width, height: 44))
        slider.addTarget(self, action: #selector(valueChanged), for: UIControl.Event.valueChanged)
        return slider
    }()
}

extension UIView {
    func makeScreenshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { (context) in
            self.layer.render(in: context.cgContext)
        }
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        guard let myText = text as? NSString else {
            return 0
        }
        // Call self.layoutIfNeeded() if your view uses auto layout
        let rect = CGSize(width: bounds.width, height: CGFloat.infinity)
        let labelSize = myText.boundingRect(with: rect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font as Any],
                                            context: nil)
        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
}

extension UIImage {
    func crop(rect: CGRect) -> UIImage {
        var scaledRect = rect
        scaledRect.origin.x *= scale
        scaledRect.origin.y *= scale
        scaledRect.size.width *= scale
        scaledRect.size.height *= scale
        guard let imageRef: CGImage = cgImage?.cropping(to: scaledRect) else {
            return self
        }
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
}
