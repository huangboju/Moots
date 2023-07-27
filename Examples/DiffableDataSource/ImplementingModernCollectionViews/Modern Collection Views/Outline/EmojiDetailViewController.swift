/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A detail view controller to visualize a selected emoji.
*/

import UIKit

class EmojiDetailViewController: UIViewController {
    
    let emoji: Emoji

    init(with emoji: Emoji) {
        self.emoji = emoji
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var emojiLabel: UILabel!
    var emojiDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up view hierarchy
        
        self.view.backgroundColor = .systemBackground
        
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .systemFont(ofSize: 60.0)
        self.emojiLabel = emojiLabel
        
        let emojiDescription = UILabel()
        emojiDescription.translatesAutoresizingMaskIntoConstraints = false
        emojiDescription.font = .preferredFont(forTextStyle: .headline)
        emojiDescription.numberOfLines = 0
        self.emojiDescription = emojiDescription
        
        self.view.addSubview(emojiLabel)
        self.view.addSubview(emojiDescription)
        
        // configure constraints
        
        NSLayoutConstraint.activate([
            // vertical:
            emojiLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            emojiDescription.topAnchor.constraint(equalToSystemSpacingBelow: emojiLabel.bottomAnchor, multiplier: 1.0),
            // horizontal:
            emojiLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emojiDescription.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emojiDescription.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.readableContentGuide.leadingAnchor)
        ])
        
        // configure content
        
        emojiLabel.text = self.emoji.text
        emojiDescription.text = self.emoji.title
    }
    
}
