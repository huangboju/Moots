//
//  ViewController.swift
//  UndoAppExample
//
//  Created by Tomasz Szulc on 12/09/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet private var undoButton: UIButton!
    @IBOutlet private var redoButton: UIButton!
    @IBOutlet private var boardView: BoardView!
    
    private var figures = [FigureView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUndoManager()
        updateUndoAndRedoButtons()
    }
    
    @IBAction func addRectangel(_ sender: Any) {
        let figureView = FigureView(frame: CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleFigureLongPressGesture))
        longPressGesture.minimumPressDuration = 0.25
        figureView.addGestureRecognizer(longPressGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        figureView.addGestureRecognizer(doubleTapGesture)
        
        addFigure(figureView)
    }
    
    /// MARK: Actions on Figures
    func addFigure(_ figure: FigureView) {
        registerUndoAddFigure(figure)
        
        boardView.addSubview(figure)
        figures.append(figure)
        
        updateUndoAndRedoButtons()
    }
    
    func removeFigure(_ figure: FigureView) {
        registerUndoRemoveFigure(figure)
        
        figure.removeFromSuperview()
        if let index = figures.index(of: figure) {
            figures.remove(at: index)
        }
    }
    
    func moveFigure(_ figure: FigureView, center: CGPoint) {
        registerUndoMoveFigure(figure)
        figure.center = center
    }
    
    /// MARK: Undo Manager
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private var _undoManager = UndoManager()
    override var undoManager: UndoManager {
        return _undoManager
    }
    
    private func observeUndoManager() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoAndRedoButtons), name: NSNotification.Name.NSUndoManagerDidUndoChange, object: undoManager)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoAndRedoButtons), name: NSNotification.Name.NSUndoManagerDidRedoChange, object: undoManager)
    }

    @objc private func updateUndoAndRedoButtons() {
        undoButton.isEnabled = undoManager.canUndo == true
        if undoManager.canUndo {
            undoButton.setTitle(undoManager.undoMenuTitle(forUndoActionName: undoManager.undoActionName), for: .normal)
        } else {
            undoButton.setTitle(undoManager.undoMenuItemTitle, for: .normal)
        }
        
        redoButton.isEnabled = undoManager.canRedo == true
        if undoManager.canRedo {
            redoButton.setTitle(undoManager.redoMenuTitle(forUndoActionName: undoManager.redoActionName), for: .normal)
        } else {
            redoButton.setTitle(undoManager.redoMenuItemTitle, for: .normal)
        }
    }
    
    /// MARK: Undo Manager Actions
    func registerUndoAddFigure(_ figure: FigureView) {
        (undoManager.prepare(withInvocationTarget: self) as? ViewController)?.removeFigure(figure)
        undoManager.setActionName("Add Figure")
    }
    
    func registerUndoRemoveFigure(_ figure: FigureView) {
        (undoManager.prepare(withInvocationTarget: self) as? ViewController)?.addFigure(figure)
        undoManager.setActionName("Remove Figure")
    }
    
    func registerUndoMoveFigure(_ figure: FigureView) {
        (undoManager.prepare(withInvocationTarget: self) as? ViewController)?.moveFigure(figure, center: figure.center)
        undoManager.setActionName("Move to \(figure.center)")
    }
    
    
    /// MARK: Gesture Recognizer
    @objc func handleDoubleTapGesture(recognizer: UITapGestureRecognizer) {
        let figureView = recognizer.view as! FigureView
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let figureSettingsVC = storyboard.instantiateViewController(withIdentifier: "FigureSettingsVC") as! FigureSettingsViewController
        figureSettingsVC.figure = figureView
        figureSettingsVC.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popoverPresentationController = figureSettingsVC.popoverPresentationController!
        popoverPresentationController.sourceView = figureView
        popoverPresentationController.sourceRect = CGRect(x: figureView.frame.width / 2.0, y: figureView.frame.height / 2.0, width: 0, height: 0)
        self.present(figureSettingsVC, animated: true, completion: nil)
    }
    
    @objc func handleFigureLongPressGesture(recognizer: UILongPressGestureRecognizer) {
        let figure = recognizer.view as! FigureView
        switch recognizer.state {
        case .began:
            registerUndoMoveFigure(figure)
            grabFigure(figure, gesture: recognizer)
        case .changed:
            moveFigure(figure, gesture: recognizer)
        case .ended:
            dropFigure(figure, gesture: recognizer)
            updateUndoAndRedoButtons()
        case .cancelled:
            dropFigure(figure, gesture: recognizer)
        default:
            break
        }
    }
    
    private func grabFigure(_ figure: FigureView, gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            figure.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            figure.alpha = 0.8
        }
        
        moveFigure(figure, gesture: gesture)
    }
    
    private func moveFigure(_ figure: FigureView, gesture: UIGestureRecognizer) {
        figure.center = gesture.location(in: self.view)
    }
    
    private func dropFigure(_ figure: FigureView, gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            figure.transform = CGAffineTransform.identity
            figure.alpha = 1.0
        }
    }
}
