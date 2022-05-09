//
//  FigureSettingsViewController.swift
//  UndoAppExample
//
//  Created by Tomasz Szulc on 13/09/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

extension FigureView {
    
    func recordBeginChanges() {
        self.changesRecorder.setValue(for: "backgroundColor", value: self.backgroundColor)
        self.changesRecorder.setValue(for: "cornerRadius", value: self.cornerRadius)
    }
    
    func revertChanges() {
        self.backgroundColor = self.changesRecorder.value(for: "backgroundColor") as? UIColor
        self.cornerRadius = self.changesRecorder.value(for: "cornerRadius") as! CGFloat
    }
    
    @objc func registerUndoChange() {
        let changes = changesRecorder.dictionary
        
        let beginBackgroundColor = changes["backgroundColor"] as! UIColor
        let beginCornerRadius = changes["cornerRadius"] as! CGFloat
        
        let colorModified = self.backgroundColor! != beginBackgroundColor
        let cornerRadiusModified = self.cornerRadius != beginCornerRadius
        
        undoManager.beginUndoGrouping()
        (undoManager.prepare(withInvocationTarget: self) as AnyObject).registerUndoChange()
        undoManager.registerUndo(withTarget: self, selector: #selector(registerUndoChange), object: nil)
        undoManager.registerUndo(withTarget: self, selector: #selector(setter: backgroundColor), object: beginBackgroundColor)
        undoManager.registerUndo(withTarget: self, selector: #selector(setter: cornerRadius), object: beginCornerRadius)
        
        if colorModified && cornerRadiusModified {
            undoManager.setActionName("Change Color and Radius")
        } else if colorModified {
            undoManager.setActionName("Change Color")
        } else if cornerRadiusModified {
            undoManager.setActionName("Change Radius")
        }
        
        undoManager.endUndoGrouping()
    }
}

class FigureSettingsViewController: UIViewController {
    
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var cornerRadiusSlider: UISlider!
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var redoButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    var figure: FigureView!
    var lockUndo: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUndoManager()
        updateUndoAndRedoButtons()
        setupUI()
        updateBeginChanges()
        
        figure.addObserver(self, forKeyPath: "cornerRadius", options: [.new, .initial], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "cornerRadius" {
            cornerRadiusSlider.value = (change![NSKeyValueChangeKey.newKey] as! NSNumber).floatValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        figure.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        revertChanges()
        figure.removeObserver(self, forKeyPath: "cornerRadius")
        figure.resignFirstResponder()
    }
    
    private func setupUI() {
        colorButtons[0].backgroundColor = UIColor.red
        colorButtons[1].backgroundColor = UIColor.blue
        colorButtons[2].backgroundColor = UIColor.purple
        colorButtons[3].backgroundColor = UIColor(white: 0.7, alpha: 1)
        
        cornerRadiusSlider.value = Float(figure.layer.cornerRadius)
    }
    
    private func updateBeginChanges() {
        figure.recordBeginChanges()
    }
    
    private func revertChanges() {
        figure.revertChanges()
    }
    
    private func updateButtons() {
        saveButton.isEnabled = true
        if lockUndo {
            self.undoButton.isEnabled = false
            self.redoButton.isEnabled = false
        }
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        figure.registerUndoChange()
        updateBeginChanges()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeColor(sender: UIButton) {
        lockUndo = true
        figure.backgroundColor = sender.backgroundColor
        updateButtons()
    }
    
    @IBAction func cornerRadiusValueChanged(sender: UISlider) {
        lockUndo = true
        figure.layer.cornerRadius = CGFloat(sender.value)
        updateButtons()
    }
    
    /// MARK: Undo Manager
    private func observeUndoManager() {
        NotificationCenter.default.addObserver(self, selector: #selector(undoManagerDidUndoNotification), name: .NSUndoManagerDidUndoChange, object: figure.undoManager)
        NotificationCenter.default.addObserver(self, selector: #selector(undoManagerDidRedoNotification), name: .NSUndoManagerDidRedoChange, object: figure.undoManager)
    }
    
    @objc func undoManagerDidUndoNotification() {
        updateUndoAndRedoButtons()
        figure.recordBeginChanges()
    }
    
    @objc func undoManagerDidRedoNotification() {
        updateUndoAndRedoButtons()
        figure.recordBeginChanges()
    }

    private func updateUndoAndRedoButtons() {
        undoButton.isEnabled = figure.undoManager.canUndo == true
        if figure.undoManager.canUndo {
            undoButton.setTitle(figure.undoManager.undoMenuTitle(forUndoActionName: figure.undoManager.undoActionName), for: .normal)
        } else {
            undoButton.setTitle(figure.undoManager.undoMenuItemTitle, for: .normal)
        }
        
        redoButton.isEnabled = figure.undoManager.canRedo == true
        if figure.undoManager.canRedo {
            redoButton.setTitle(figure.undoManager.redoMenuTitle(forUndoActionName: figure.undoManager.redoActionName), for: .normal)
        } else {
            redoButton.setTitle(figure.undoManager.redoMenuItemTitle, for: .normal)
        }
    }
}
