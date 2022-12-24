//
//  AvatarInfo.swift
//  DragNDrop
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 Appcoda. All rights reserved.
//

import Cocoa

class AvatarInfo: NSObject, Codable {
        
    var imageData: Data?
    var colorData: Data?
    var quote: String?
    
    override init() {
        super.init()
    }
 
        
    func setImageData(using image: NSImage) {
        imageData = image.tiffRepresentation
    }
    
    
    func setColorData(using color: NSColor) {
        guard let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) else { return }
        self.colorData = colorData
    }
    
    
    func getImage() -> NSImage? {
        guard let imageData = imageData else { return nil }
        return NSImage(data: imageData)
    }
    
    
    func getColor() -> NSColor? {
        guard let data = colorData, let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else { return nil }
        return color
    }
    
    
    class func getUTIType() -> String {
        return (Bundle.main.bundleIdentifier ?? "") + ".avatarInfoCustomUTI"
    }
}


// MARK: - NSPasteboardWriting

extension AvatarInfo: NSPasteboardWriting {
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        var types = [NSPasteboard.PasteboardType]()
        types.append(NSPasteboard.PasteboardType(rawValue: AvatarInfo.getUTIType()))
        
        if let _ = imageData {
            types.append(.tiff)
        }

        if let _ = quote {
            types.append(.string)
        }

        return types
    }

    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        return nil
    }
}


// MARK: - NSPasteboardItemDataProvider

extension AvatarInfo: NSPasteboardItemDataProvider {
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
        switch type {
            case .init(AvatarInfo.getUTIType()):
                guard let encodedSelf = try? JSONEncoder().encode(self) else { return }
                item.setData(encodedSelf, forType: type)
            
            case .tiff:
                guard let imageData = imageData else { return }
                item.setData(imageData, forType: type)
            
            case .string:
                guard let quoteData = quote?.data(using: .utf8) else { return }
                item.setData(quoteData, forType: type)
            
            default: break
        }
    }
}
