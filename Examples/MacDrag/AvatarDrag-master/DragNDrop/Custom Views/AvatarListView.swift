//
//  AvatarListView.swift
//  DragNDrop
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 Appcoda. All rights reserved.
//

import Cocoa

class AvatarListView: NSView {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    // MARK: - Properties
    
    var avatars = [AvatarInfo]()
    
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: AvatarInfo.getUTIType())])
    }
    
}



// MARK: - NSTableViewDataSource

extension AvatarListView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return avatars.count
    }
}


// MARK: - NSTableViewDelegate

extension AvatarListView: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let avatarInfo = avatars[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("avatarColumnID") {
            
            guard let imageView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "avatarImageView"), owner: self) as? NSImageView else { return nil }
            imageView.image = avatarInfo.getImage()
            return imageView
        
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("favColorColumnID") {
            
            guard let customView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "favColorView"), owner: self) else { return nil }
            customView.wantsLayer = true
            customView.layer?.backgroundColor = avatarInfo.getColor()?.cgColor
            return customView
            
        } else {
            
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "quoteCellID"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = avatarInfo.quote ?? ""
            return cellView
        }
    }
    
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        tableView.setDropRow(-1, dropOperation: .on)
        return .copy
    }
    
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        guard let draggedItem = info.draggingPasteboard.pasteboardItems?.first,
         let avatarInfoData = draggedItem.data(forType: NSPasteboard.PasteboardType(AvatarInfo.getUTIType())),
         let draggedAvatarInfo = try? JSONDecoder().decode(AvatarInfo.self, from: avatarInfoData)
         else { return false }

        avatars.append(draggedAvatarInfo)
        tableView.reloadData()

        return true
    }
}
