//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class LockManager {
    var options = LockOptions()
    
    static let sharedInstance = LockManager()
    // 私有化构造方法，阻止其他对象使用这个类的默认的'()'构造方法
    private init () {
        
    }
    
    func hasPassword() -> Bool {
        return CoreArchive.strFor(PASSWORD_KEY + options.passwordKeySuffix) != nil
    }
    
    func removePassword(key: String) {
        CoreArchive.removeValueFor(PASSWORD_KEY + options.passwordKeySuffix)
    }
}
