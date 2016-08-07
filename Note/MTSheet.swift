//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class MTSheet: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    var selectedIndex: ((Int) -> Void)?
    var cancelAction: (() -> Void)?
    
    private let tableView = UITableView()
    private var listData: [(icon: String, title: String)]!
    private var title: String!
    private let cusomerView = UIView()
    private let SCREEN_SIZE = UIScreen.mainScreen().bounds.size
    
    init(list: [(icon: String, title: String)], title: String, selectedIndex: ((Int) -> Void)? = nil, cancelHandle: (() -> Void)? = nil) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: SCREEN_SIZE))
        
        tableView.frame = CGRect(x: 5, y: 0, width: SCREEN_SIZE.width - 10, height: 44 * CGFloat(list.count) + 45)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
        tableView.layer.cornerRadius = 5
        cusomerView.addSubview(tableView)
        
        let cancelLabel = UILabel(frame: CGRect(x: 5, y: tableView.frame.height + 10, width: tableView.frame.width, height: 44))
        cancelLabel.layer.cornerRadius = 5
        cancelLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
        
        cancelLabel.text = "取消"
        cancelLabel.textAlignment = .Center
        cancelLabel.textColor = .blueColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        cancelLabel.userInteractionEnabled = true
        cancelLabel.addGestureRecognizer(tap)
        cusomerView.addSubview(cancelLabel)
        
        cusomerView.frame = CGRect(x: 0, y: SCREEN_SIZE.height, width: SCREEN_SIZE.width, height: tableView.frame.height + 60)
        cusomerView.backgroundColor = .clearColor()
        addSubview(cusomerView)
        
        listData = list
        self.title = title
        
        self.selectedIndex = selectedIndex
        cancelAction = cancelHandle
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view is MTSheet
    }
    
    func animeData() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        UIView.animateWithDuration(0.25) { [unowned self] in
            self.backgroundColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 0.6)
            self.cusomerView.frame.origin.y = self.SCREEN_SIZE.height - self.cusomerView.frame.height
        }
    }
    
    func show() {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.view.addSubview(self)
        
        animeData()
    }
    
    func tapped() {
        UIView.animateWithDuration(0.25, animations: { [unowned self] in
            self.alpha = 0
            self.cusomerView.frame.origin.y = self.SCREEN_SIZE.height
            }) { [unowned self] (finished)  in
                if finished {
                    for subview in self.cusomerView.subviews {
                        subview.removeFromSuperview()
                    }
                }
        }
    }
    
    func hide() {
        if let cancelAction = self.cancelAction {
            cancelAction()
        }
        tapped()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellId = "TitleCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            }
            cell?.textLabel?.text = title
            cell?.textLabel?.textAlignment = .Center
            cell?.userInteractionEnabled = false
            return cell ?? UITableViewCell()
        } else {
            let cellId = "DownSheetCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? SheetCell
            if cell == nil {
                cell = SheetCell(style: .Default, reuseIdentifier: cellId)
            }
            cell?.setData(listData[indexPath.row - 1])
            return cell ?? SheetCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 45 : 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tapped()
        if let selectedIndex = self.selectedIndex {
            selectedIndex(indexPath.row)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SheetCell: UITableViewCell {
    private let leftView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.backgroundColor = .clearColor()
        contentView.addSubview(titleLabel)
        contentView.addSubview(leftView)
        selectionStyle = .None
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftView.frame = CGRect(x: 20, y: (frame.height - 30) / 2, width: 30, height: 30)
        titleLabel.frame = CGRect(x: leftView.frame.maxX + 15, y: (frame.height - 20) / 2, width: 150, height: 20)
        titleLabel.textColor = .blueColor()
    }
    
    func setData(item: (icon: String, title: String)) {
        leftView.image = UIImage(named: item.icon)
        titleLabel.text = item.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
