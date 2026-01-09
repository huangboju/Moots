import Foundation

/// ScreenRecord 模块统一日志入口，便于后续替换成 os_log / 第三方日志 / 上报等。
enum ScreenRecordLog {
    enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARN"
        case error = "ERROR"
    }

    static func log(_ level: Level, _ message: @autoclosure () -> String,
                    file: StaticString = #fileID,
                    function: StaticString = #function,
                    line: UInt = #line) {
        // 当前先走 NSLog，后续替换只需改这里
        NSLog("[%@] %@ (%@:%u %@)", level.rawValue, message(), String(describing: file), line, String(describing: function))
    }
}


