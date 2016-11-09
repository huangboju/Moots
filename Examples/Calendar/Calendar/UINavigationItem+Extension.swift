//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension UINavigationItem {
    func showTitleView(text: String) {
        let titleView = TitleView()
        titleView.setText(str: text)
        self.titleView = titleView
    }
    
    func hideTitleView() {
        titleView = nil
    }
}
