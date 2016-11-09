//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class TitleView: UIView {
    var textLabel: UILabel?
    var indicatorView: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        addSubview(indicatorView!)
        textLabel = UILabel()
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(textLabel!)
    }
    
    func setText(str: String) {
        indicatorView?.startAnimating()
        textLabel?.text = str + "..."
        textLabel?.sizeToFit()
        textLabel?.frame.origin.x = indicatorView!.frame.maxX + 10
        frame.size = CGSize(width: 10 + indicatorView!.frame.width + textLabel!.frame.width, height: max(indicatorView!.frame.height, textLabel!.frame.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
