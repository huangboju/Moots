//
//  ExpandedController.swift
//  TransitionsLibrary
//
//  Created by 黄伯驹 on 2017/7/15.
//  Copyright © 2017年 xiAo_Ju. All rights reserved.
//

class ExpandedController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var openingFrame = CGRect.zero

    let colors = [
        UIColor(hex: 0xFFD36C),
        UIColor(hex: 0x49B2BD),
        UIColor(hex: 0xDC3565),
        UIColor(hex: 0xA692CB),
        UIColor(hex: 0xFFD36C),
        UIColor(hex: 0x49B2BD)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ExpandedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}

extension ExpandedController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = colors[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame ?? .zero
        let frameToOpenFrom = collectionView.convert(attributesFrame, to: collectionView.superview)
        openingFrame = frameToOpenFrom

        let testVC = TestController()
        testVC.transitioningDelegate = self
        testVC.modalPresentationStyle = .custom
        testVC.view.backgroundColor = colors[indexPath.row]

        present(testVC, animated: true, completion: nil)
    }
}

extension ExpandedController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimator =  ExpandAnimator.animator
        presentAnimator.openingFrame = openingFrame
        return presentAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimator =  ExpandAnimator.animator
        dismissAnimator.openingFrame = openingFrame
        dismissAnimator.transitionMode = .dismiss
        return dismissAnimator
    }
}
