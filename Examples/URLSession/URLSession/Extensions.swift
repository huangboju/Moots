//
//  Extensions.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2017/3/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}

extension String {
    // 32 cell.textLabel的padding
    func heightWithConstrainedWidth(width: CGFloat = UIScreen.main.bounds.width - 32, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        //        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        let label = UILabel(frame: CGRect(origin: .zero, size: constraintRect))
        label.text = self
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        return label.frame.height
    }
}

extension UINavigationBar {

    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.isHidden = true
    }

    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.isHidden = false
    }

    fileprivate func hairlineImageViewInNavigationBar(_ view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
            return (view as? UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
}
