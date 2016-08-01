//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct CoreArchive {
    static func setStr(value: String?, key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
    
    static func strFor(key: String) -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(key)
    }
    
    static func removeValueFor(key: String) {
        setStr(nil, key: key)
    }
    
    static func setInt(value: Int, key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(value, forKey: key)
        defaults.synchronize()
    }
    
    static func intFor(key: String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    static func setFloat(value: Float, key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(value, forKey: key)
        //如果程序意外退出数据不会被系统写入到该文件，所以，要使用synchronize()命令直接同步到文件里
        defaults.synchronize()
    }
    
    static func floatFor(key: String) -> Float {
        return NSUserDefaults.standardUserDefaults().floatForKey(key)
    }
    
    static func setBool(value: Bool, key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(value, forKey: key)
        defaults.synchronize()
    }
    
    static func boolFor(key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    //MARK: - 归档
    static func archiveRoot(object: AnyObject, toFile path: String) -> Bool {
        return NSKeyedArchiver.archiveRootObject(object, toFile: path)
    }
    
    static func removeRootObjectWithFile(path: String) -> Bool {
        return archiveRoot("", toFile: path)
    }
    
    func unarchiveObjectWithFile(path: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path)
    }
}
