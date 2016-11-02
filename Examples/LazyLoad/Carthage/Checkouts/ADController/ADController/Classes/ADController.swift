//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

public enum TransitionType: String {
    case overlayVertical = "overlayVertical"
    case overlayHorizontal = "overlayHorizontal"
    case bottomToTop = "bottomToTop"
    case topToBottom = "topToBottom"
    case leftToRight = "leftToRight"
    case rightToLeft = "rightToLeft"
}

public enum CloseButtonPosition: String {
    case bottom
    case topRight
}

public class ADController: UIViewController {

    public var contentSize = CGSize() {
        willSet {
            ADConfig.shared.ADViewSize = newValue
        }
    }
    public var showTimeInterval = ShowTimeInterval.day
    public var selectedHandel: ((Int, UIViewController) -> Void)?
    public var closedHandel: (() -> Void)?
    public var closeButtonPosition = CloseButtonPosition.bottom {
        willSet {
            ADConfig.shared.closeButtonPosition = newValue
        }
    }
    public var isShowPageControl = false
    public var closeButtonImage: UIImage? {
        willSet {
            ADConfig.shared.closeButtonImage = newValue
        }
    }
    public var images = [UIImage]() {
        willSet {
            ADConfig.shared.firstImage = newValue[0]
        }
    }

    private var bundleImage: UIImage? {
        var bundle = Bundle(for: classForCoder)
        if let resourcePath = bundle.path(forResource: "ADController", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        return UIImage(named: "ic_btn_close", in: bundle, compatibleWith: nil)
    }

    private lazy var presentTransitionDelegate = SDEModalTransitionDelegate()

    private lazy var bannerView: BannerView = {
        let size = ADConfig.shared.ADViewSize
        let bannerView = BannerView(frame: CGRect(origin: .zero, size: size))
        bannerView.alpha = ADConfig.shared.isOverlay ? 0 : 1
        return bannerView
    }()
    
    private var showedDate: String {
        return "\(classForCoder)showed_date"
    }
    
    private var adDateKey: String {
        return "\(classForCoder)AD_date"
    }

    public convenience init(type: TransitionType) {
        self.init()
        ADConfig.shared.transitionType = type
        transitioningDelegate = presentTransitionDelegate
        modalPresentationStyle = .custom
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        bannerView.set(images: images)
        
        bannerView.handleBack = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectedHandel?($0, strongSelf)
        }
        bannerView.showPageControl = isShowPageControl
        view.addSubview(bannerView)
        if closeButtonImage == nil {
            ADConfig.shared.closeButtonImage = bundleImage
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.setShowed(Date())
        UIView.animate(withDuration: 0.3, animations: {
            self.bannerView.alpha = 1
        })
    }

    public func isCanShowing(date: Date) -> Bool {
        guard let adDate = Constants.adDate else {
            Constants.set(date)
            return true
        }
        if date != adDate {
            Constants.set(date)
            return true
        }
        let oldDate = Constants.oldDate
        return -oldDate.timeIntervalSinceNow >= showTimeInterval.rawValue
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("⚠️⚠️⚠️\(classForCoder)")
    }
}

public enum ShowTimeInterval: TimeInterval {
    case hour = 3600
    case halfDay = 43200
    case day = 86400
}

struct Constants {
    static let adDateKey = "ADController_ad_date"
    static let showedDateKey = "ADController_showed_date"
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static var oldDate: Date {
        return (UserDefaults.standard.value(forKey: showedDateKey) as? Date) ?? Date()
    }
    
    static var adDate: Date? {
       return UserDefaults.standard.value(forKey: adDateKey) as? Date
    }
    
    static func set(_ date: Date) {
        UserDefaults.standard.set(date, forKey: adDateKey)
    }

    static func setShowed(_ date: Date) {
        UserDefaults.standard.set(date, forKey: showedDateKey)
    }
}

class ADConfig {
    var ADViewSize = CGSize(width: Constants.screenWidth * 0.618, height: Constants.screenHeight * 0.618)
    var transitionType = TransitionType.overlayVertical {
        willSet {
            isVertical = newValue == .overlayVertical
            isOverlay = isVertical || newValue == .overlayHorizontal
        }
    }
    var closeButtonImage: UIImage?
    var firstImage = UIImage()
    var lastImage: UIImage?
    var isVertical = true
    var isOverlay = true
    var closeButtonPosition = CloseButtonPosition.bottom
    static let shared = ADConfig()
    private init() {}
}
