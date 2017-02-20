//
//  LabelView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

enum PULLINGSTATE {
    case up
    case down
}

let LabelHeight: CGFloat = 50.0

class LabelView: UIView {

    let kPullingDownString = "下拉即可刷新..."
    let kPullingUpString = "上拉即可刷新"
    let kReleaseString = "松开即可刷新..."

    fileprivate var kPullingString = ""
    fileprivate var titleLabel: UILabel!

    var loading: Bool = false
    var progress: CGFloat = 0.0 {
        didSet {
            titleLabel.alpha = progress
            if !loading {
                titleLabel.text = progress >= 1.0 ? kReleaseString : kPullingString
            } else {
                titleLabel.text = progress >= 0.91 ? kReleaseString : kPullingString
            }
        }
    }
    var state: PULLINGSTATE = .down {
        didSet {
            kPullingString = state == .up ? kPullingUpString : kPullingDownString
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setUp() {
        state = .down
        titleLabel = UILabel(frame: CGRect(x: 0, y: frame.height / 2 - LabelHeight / 2, width: frame.size.width, height: LabelHeight))
        titleLabel.text = kPullingString
        titleLabel.textColor = UIColor.black
        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(titleLabel)
    }
}
