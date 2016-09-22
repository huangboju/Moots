//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

protocol DiscoverCellDataSource {
    var title: String { get }
    var selected: Bool { get }
}

protocol DiscoverCellDelegate {
    func didSelected(_ sender: UIButton)
    var selectedColor: UIColor { get }
}

class DiscoverCell: UITableViewCell {
    var dataSource: DiscoverCellDataSource?
    var delegate: DiscoverCellDelegate?
    
    var likeButton: UIButton!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        likeButton = UIButton(frame: CGRect(x: frame.width - 60 - 15, y: (frame.height - 30) / 2, width: 60, height: 30))
        likeButton.addTarget(self, action: #selector(selectedItem), for: .touchUpInside)
        contentView.addSubview(likeButton)
    }
    
    func configure(withDataSource dataSource: DiscoverCellDataSource, delegate: DiscoverCellDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        
        textLabel?.backgroundColor = .clear
        textLabel?.text = dataSource.title
        likeButton.isSelected = dataSource.selected
        likeButton.backgroundColor = delegate.selectedColor
    }
    
    func selectedItem(_ sender: UIButton) {
        delegate?.didSelected(sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
