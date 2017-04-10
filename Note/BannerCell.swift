//
//  Copyright © 2016 cmcaifu.com. All rights reserved.
//

class BannerCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = bounds
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = true
        contentView.addSubview(imageView)
    }

    func setData(urlStr: String) {
        if let url = NSURL(string: urlStr) {
            imageView.kf_setImageWithURL(url)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
