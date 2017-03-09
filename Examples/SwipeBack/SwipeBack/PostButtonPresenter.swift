//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

protocol PostButtonPresenter {
    var postButton: AssistiveTouch { set get }
    func addPostButton(selector: Selector)
}

extension PostButtonPresenter where Self: UIViewController {
    

    func removePostButton() {
        postButton.removeFromSuperview()
    }
}
