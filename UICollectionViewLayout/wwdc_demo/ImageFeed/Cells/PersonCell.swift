/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Collection view cell sublass representing a person.
*/

import UIKit

class PersonCell: UICollectionViewCell {
    static let identifier = "kListCollectionViewCell"
    
    let bgView = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let noteLabel = UILabel()
    let updateIndicator = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        
        self.backgroundColor = UIColor.appBackgroundColor
        self.layer.cornerRadius = 20

        bgView.frame = self.bounds
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1019638271)
        self.backgroundView = bgView
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1021243579)
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        let labelStackView = UIStackView()
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.isBaselineRelativeArrangement = true
        labelStackView.spacing = 21.0
        self.addSubview(labelStackView)
        
        updateIndicator.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        updateIndicator.translatesAutoresizingMaskIntoConstraints = false
        updateIndicator.backgroundColor = UIColor.cyan
        updateIndicator.layer.cornerRadius = 5
        updateIndicator.isHidden = true
        self.addSubview(updateIndicator)
        
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(nameLabel)
        
        noteLabel.textColor = UIColor.white
        noteLabel.alpha = 0.3
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(noteLabel)

        setupConstraints(labelStackView: labelStackView)
    }
    
    func setupConstraints(labelStackView: UIStackView) {
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 54.0),
            imageView.heightAnchor.constraint(equalToConstant: 54.0),
    
            labelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.0),
            labelStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            labelStackView.firstBaselineAnchor.constraint(equalTo: self.topAnchor, constant: 32.0),
    
            updateIndicator.centerYAnchor.constraint(equalTo: noteLabel.centerYAnchor),
            updateIndicator.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -16),
            updateIndicator.widthAnchor.constraint(equalToConstant: 10),
            updateIndicator.heightAnchor.constraint(equalToConstant: 10)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override var isHighlighted: Bool {
        didSet {
            let duration = isHighlighted ? 0.45 : 0.4
            let transform = isHighlighted ?
                CGAffineTransform(scaleX: 0.96, y: 0.96) : CGAffineTransform.identity
            let bgColor = isHighlighted ?
                UIColor(white: 1.0, alpha: 0.2) : UIColor(white: 1.0, alpha: 0.1)
            let animations = {
                self.transform = transform
                self.bgView.backgroundColor = bgColor
            }
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: animations,
                           completion: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateIndicator.isHidden = true
    }
    
    var person: Person? {
        didSet {
            guard let aPerson = person, let personName = aPerson.name else { return }
            
            nameLabel.text = personName + "’s Feed"
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            noteLabel.text = "Updated " + formatter.string(from: aPerson.lastUpdate)
            
            if let imgName = aPerson.imgName {
                imageView.image = UIImage(named: imgName)
            }
            
            if let updated = aPerson.isUpdated {
                updateIndicator.isHidden = !updated
                
                if updated {
                    noteLabel.text = "Updated Now"
                }
            }
        }
    }
}
