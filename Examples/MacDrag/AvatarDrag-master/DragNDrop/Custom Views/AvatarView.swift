//
//  AvatarView.swift
//  DragNDrop
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 Appcoda. All rights reserved.
//

import Cocoa

class AvatarView: NSView {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var quoteLabel: NSTextField!

    
    // MARK: - Properties
    
    var avatarInfo = AvatarInfo()
    
    let supportedTypes: [NSPasteboard.PasteboardType] = [.tiff, .color, .string, .fileURL]
    
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Enable layer in self view.
        self.wantsLayer = true
        
        // Enable layer in the image view and
        // set corner radius and border.
        imageView.wantsLayer = true
        imageView.layer?.cornerRadius = 120.0
        imageView.layer?.borderWidth = 5.0
        imageView.layer?.borderColor = NSColor.lightGray.cgColor
        
        self.registerForDraggedTypes(supportedTypes)
    }
    
    
    // MARK: - Methods Implementation
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let canReadPasteboardObjects = sender.draggingPasteboard.canReadObject(forClasses: [
            NSImage.self,
            NSColor.self,
            NSString.self,
            NSURL.self
        ], options: acceptableUTITypes())

        if canReadPasteboardObjects {
            highlight()
            return .copy
        }

        return NSDragOperation()
    }
    
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboardObjects = sender.draggingPasteboard.readObjects(forClasses: [NSImage.self, NSColor.self, NSString.self, NSURL.self], options: acceptableUTITypes()), pasteboardObjects.count > 0 else {
            return false
        }
        
        pasteboardObjects.forEach { (object) in
            if let image = object as? NSImage {
                avatarInfo.setImageData(using: image)
            }

            if let color = object as? NSColor {
                avatarInfo.setColorData(using: color)
            }

            if let quote = object as? NSString {
                avatarInfo.quote = quote as String
            }

            if let url = object as? NSURL {
                self.handleFileURLObject(url as URL)
            }
        }
        
        sender.draggingDestinationWindow?.orderFrontRegardless()
        return true
    }
    
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        imageView.image = avatarInfo.getImage()
        imageView.layer?.borderColor = avatarInfo.getColor()?.cgColor
        quoteLabel.stringValue = avatarInfo.quote ?? ""
    }
    
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        unhighlight()
    }


    override func draggingExited(_ sender: NSDraggingInfo?) {
        unhighlight()
    }
    
    
    func acceptableUTITypes() -> [NSPasteboard.ReadingOptionKey : Any] {
        let types = [NSImage.imageTypes, NSString.readableTypeIdentifiersForItemProvider].flatMap { $0 }
        return [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes : types]
    }
    
    
    func handleFileURLObject(_ url: URL) {
        if let image = NSImage(contentsOfFile: url.path) {
            avatarInfo.setImageData(using: image)
        } else {
            guard let text = try? NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) else { return }
            avatarInfo.quote = text as String
        }
    }
    
    
    func highlight() {
        self.layer?.borderColor = NSColor.controlAccentColor.cgColor
        self.layer?.borderWidth = 2.0
    }
    
    
    func unhighlight() {
        self.layer?.borderColor = NSColor.clear.cgColor
        self.layer?.borderWidth = 0.0
    }
}



// MARK: - NSDraggingSource

extension AvatarView: NSDraggingSource {
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .copy
    }
    
    
    func draggingSession(_ session: NSDraggingSession, willBeginAt screenPoint: NSPoint) {

    }


    func draggingSession(_ session: NSDraggingSession, movedTo screenPoint: NSPoint) {

    }


    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {

    }
    
    
    override func mouseDragged(with event: NSEvent) {
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setDataProvider(avatarInfo, forTypes: [.init(AvatarInfo.getUTIType()), .tiff, .string])
        
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        
        let pdfData = self.dataWithPDF(inside: self.bounds)
        let imageFromPDF = NSImage(data: pdfData)
        draggingItem.setDraggingFrame(self.bounds, contents: imageFromPDF)
        
        beginDraggingSession(with: [draggingItem], event: event, source: self)
    }
}
