//
//  BlendingController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class BlendingController: UIViewController {
    
    /*
     These strings represent the actual blend mode constants that are passed to CGContextSetBlendMode and so should not be localized in the context of this sample.
     */
    let blendModes: [String] = [
        // PDF Blend Modes.
        "Normal",
        "Multiply",
        "Screen",
        "Overlay",
        "Darken",
        "Lighten",
        "ColorDodge",
        "ColorBurn",
        "SoftLight",
        "HardLight",
        "Difference",
        "Exclusion",
        "Hue",
        "Saturation",
        "Color",
        "Luminosity",
        // Porter-Duff Blend Modes.
        "Clear",
        "Copy",
        "SourceIn",
        "SourceOut",
        "SourceAtop",
        "DestinationOver",
        "DestinationIn",
        "DestinationOut",
        "DestinationAtop",
        "XOR",
        "PlusDarker",
        "PlusLighter",
        // If Quartz provides more blend modes in the future, add them here.
    ]

    @IBOutlet weak var picker: UIPickerView!
    
    var colors: [UIColor] = []
    
    fileprivate lazy var qbv: QuartzBlendingView = {
        let quartzBlendingView = QuartzBlendingView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 200))
        return quartzBlendingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(qbv)
        
        picker.delegate = self
        picker.dataSource = self
        
        colors = [
            UIColor.red,
            UIColor.green,
            UIColor.blue,
            UIColor.yellow,
            UIColor.magenta,
            UIColor.cyan,
            UIColor.orange,
            UIColor.purple,
            UIColor.brown,
            UIColor.white,
            UIColor.lightGray,
            UIColor.darkGray,
            UIColor.black
        ]

        colors.sort { (obj1, obj2) in
            return obj1.luminance < obj2.luminance
        }

        picker.selectRow(colors.firstIndex(of: qbv.destinationColor) ?? 0, inComponent: 0, animated: false)
        
        picker.selectRow(colors.firstIndex(of: qbv.sourceColor) ?? 0, inComponent: 1, animated: false)
        picker.selectRow(Int(qbv.blendMode.rawValue), inComponent: 2, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var squareString: String?
}

extension BlendingController:  UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 2 ? blendModes.count : colors.count
    }
}


extension BlendingController:  UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 2 ? 200 : 40
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 2 {
            return NSAttributedString(string: blendModes[row])
        }

        if squareString == nil {
            // This is a Unicode character for a simple square block.
            squareString = "█"
        }
        let attributes = [
            NSAttributedString.Key.foregroundColor : colors[row],
            NSAttributedString.Key.backgroundColor : UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: squareString!, attributes: attributes)
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        qbv.destinationColor = colors[picker.selectedRow(inComponent: 0)]
        qbv.sourceColor = colors[picker.selectedRow(inComponent: 1)]
        qbv.blendMode = CGBlendMode(rawValue: Int32(picker.selectedRow(inComponent: 2)))!
    }
}

extension UIColor {
    // Calculate the luminance for an arbitrary UIColor instance
    var luminance: CGFloat {
        let cgColor = self.cgColor
        let components = cgColor.components!
        var luminance: CGFloat = 0.0
        
        switch cgColor.colorSpace!.model {
        case .monochrome:
            // For grayscale colors, the luminance is the color value
            luminance = components[0]
        case .rgb:
            /*
             For RGB colors, we calculate luminance assuming sRGB Primaries as per http://en.wikipedia.org/wiki/Luminance_(relative).
             */
            luminance = 0.2126 * components[0] + 0.7152 * components[1] + 0.0722 * components[2]
        default:
            /*
             We don't implement support for non-gray, non-rgb colors at this time. Because our only consumer is colorSortByLuminance, we return a larger than normal value to ensure that these types of colors are sorted to the end of the list.
             */
            luminance = 2.0
        }
        return luminance
    }
}
