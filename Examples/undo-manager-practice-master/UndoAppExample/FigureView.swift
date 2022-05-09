//
//  FigureView.swift
//  UndoAppExample
//
//  Created by Tomasz Szulc on 12/09/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class FigureView: UIView {
    
    var changesRecorder = ChangesRecorder()
    private let privateUndoManager = UndoManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.privateUndoManager.groupsByEvent = false
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let defaultColor = UIColor(white: 0.7, alpha: 1)
        backgroundColor = defaultColor
        layer.borderColor = defaultColor.cgColor
        layer.borderWidth = 1.0
    }
    
    override var undoManager: UndoManager {
        return privateUndoManager
    }
    
    @objc var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }

        get {
            return layer.cornerRadius
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
