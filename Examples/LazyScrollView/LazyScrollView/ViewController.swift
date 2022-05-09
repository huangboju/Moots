//
//  ViewController.swift
//  LazyScrollView
//
//  Created by 伯驹 黄 on 2016/12/9.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var lazyScrollView: LazyScrollView = {
        let lazyScrollView = LazyScrollView(frame: self.view.bounds)
        lazyScrollView.register(viewClass: TestView.self, forViewReuse: "TestView")
        lazyScrollView.dataSource = self
        lazyScrollView.lazyDelegate = self
        return lazyScrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDatas()

        view.addSubview(lazyScrollView)
    }
    
    lazy var models: [RectModel] = []
    lazy var viewsData: [String: String] = [:]

    func setDatas() {
        for i in 0..<500 {
            let lazyID = "\(i / 10)/\(i % 10)"
            let model = RectModel(absRect: CGRect(x: 10 + CGFloat(i % 2) * 120, y: CGFloat(i / 2) * 120, width: 110, height: 110), lazyID: lazyID)
            models.append(model)
            viewsData[lazyID] = lazyID
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: LazyScrollViewDataSource {
    func numberOfItems(in scrollView: LazyScrollView) -> Int {
        return models.count
    }

    func scrollView(_ scrollView: LazyScrollView, rectModelAt index: Int) -> RectModel {
        return models[index]
    }

    func scrollView(_ scrollView: LazyScrollView, itemBy lazyID: String) -> UIView {
        return scrollView.dequeueReusableItem(with: "TestView")
    }
}

extension ViewController: LazyScrollViewDelegate {
    func scrollView(_ scrollView: LazyScrollView, didSelectItemAt index: String) {
        print(index)
    }
}

