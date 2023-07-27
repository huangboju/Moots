/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A generic NSCollectionViewItem that has an NSTextField and an enclosing NSBox
*/

import Cocoa

class TextItem: NSCollectionViewItem {

    static let reuseIdentifier = NSUserInterfaceItemIdentifier("text-item-reuse-identifier")

    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            updateSelectionHighlighting()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateSelectionHighlighting()
        }
    }

    private func updateSelectionHighlighting() {
        if !isViewLoaded {
            return
        }

        let showAsHighlighted = (highlightState == .forSelection) ||
            (isSelected && highlightState != .forDeselection) ||
            (highlightState == .asDropTarget)

        textField?.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
        if let box = view as? NSBox {
            box.fillColor = showAsHighlighted ? .selectedControlColor : .cornflowerBlue
        }
    }
}
