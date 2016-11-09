//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import EventKit

enum EventDateType: Int {
    case today = 0
    case thisWeek
    case thisMonth
    case thisYear
}

enum EventTitleType: String {
    case sale = "开售"
    case repayment = "还款"
}

class EventManger {
    private lazy var store = EKEventStore()
    
    typealias callBack = ((_ success: Bool, _ error: NSError?) -> Void)?
    
    static let shared = EventManger()
    // 私有化构造方法，阻止其他对象使用这个类的默认的'()'构造方法
    private init () {
        store.requestAccess(to: .event) { [weak self] (bool, error) in
            print(bool ? "⏰ 初始化成功" : "⏰ 初始化失败")
            if !bool {
                guard let strongSelf = self else { return }
                strongSelf.store.reset()
            }
        }
    }
    
    func createEvent(title: String, notes: String? = nil, relativeOffset: TimeInterval = 300, alarmDate: Date? = nil, startDate: Date, titleType: EventTitleType = .repayment, handle: callBack = nil) {
        for aTitle in getEventTitles(titleType: titleType) {
            if title.contains(aTitle) {
                print("⏰ 提醒已存在")
                if let handle = handle {
                    handle(false, nil)
                }
                return
            }
        }
        let newEvent = EKEvent(eventStore: store)
        var alarm: EKAlarm!
        if titleType == .repayment {
            alarm =  EKAlarm(absoluteDate: alarmDate ?? Date(year: startDate.year, month: startDate.month, day: startDate.day, hour: 9, minute: 0, second: 0))
        } else {
            alarm = EKAlarm(relativeOffset: -relativeOffset) //（提醒时间） 以开始时间为0点，负前正后
        }
        newEvent.title = "城满财富-" + title + titleType.rawValue + "提醒"
        newEvent.notes = notes //备注
        newEvent.addAlarm(alarm) // 提醒时间
        newEvent.startDate = startDate // 事件开始时间
        newEvent.endDate = newEvent.startDate.addingTimeInterval(300) // 事件结束时间
        newEvent.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(newEvent, span: .thisEvent)
            print("⏰ 提醒添加成功")
            if let handle = handle {
                handle(true, nil)
            }
        } catch let error as NSError {
            if let handle = handle {
                handle(false, error)
            }
            store.reset() // 失败后必须重置
            print (error, "⏰ 提醒添加失败")
        }
    }
    
    func remove(_ event: EKEvent, handle: callBack = nil) {
        //FIXME: 删除系统事件出错后，不能继续删除
        do {
            try store.remove(event, span: .thisEvent)
            if let handle = handle {
                handle(true, nil)
            }
            print("⏰ 提醒删除成功")
        } catch let error as NSError {
            if let handle = handle {
                handle(false, error)
            }
            store.reset()
            print (error, "⏰ 提醒删除失败")
        }
    }
    
    func remove(eventfor identifier: String, handle: callBack = nil) {
        for event in getEvents() {
            if event.eventIdentifier == identifier {
                remove(event, handle: { success, error in
                    if let handle = handle {
                        handle(false, error)
                    }
                })
                break
            }
        }
    }
    
    func getEventTitles(dateType: EventDateType = .thisYear, titleType: EventTitleType) -> [String] {
        var saleTitles = [String]()
        var repaymentTitles = [String]()
        getEvents(dateType).forEach { (event) in
            if event.title.contains("城满财富") {
                let arr = event.title.components(separatedBy: "-")
                if arr[1].contains("开售提醒") {
                    saleTitles.append(arr[1].components(separatedBy:"开")[0])
                } else if arr[1].contains("还款提醒") {
                    repaymentTitles.append(arr[1].components(separatedBy:"还")[0])
                } else {
                    fatalError("⏰ 请检查title格式")
                }
            }
        }
        return titleType == .sale ? saleTitles : repaymentTitles
    }
    
    func getEvents(_ type: EventDateType = .today) -> [EKEvent] {
        var startDate: Date!
        var endDate: Date!
        let year = Date().year
        let month = Date().month
        let day = Date().day
        let weekDay = Date().weekday
        switch type {
        case .today:
            startDate = Date(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
            endDate = Date(year: year, month: month, day: day, hour: 23, minute: 59, second: 59)
        case .thisWeek:
            startDate = Date(year: year, month: month, day: day - weekDay - 1, hour: 0, minute: 0, second: 0)
            endDate = Date(year: year, month: month, day: day - weekDay + 7, hour: 23, minute: 59, second: 59)
        case .thisMonth:
            startDate = Date(year: year, month: month, day: 1, hour: 0, minute: 0, second: 0)
            endDate = Date(year: year, month: month, day: daysIntMonth, hour: 23, minute: 59, second: 59)
        case .thisYear:
            startDate = Date(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0)
            endDate = Date(year: year, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        }
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = store.events(matching: predicate)
        return events
    }
    
    private var daysIntMonth: Int {
        let date = Date()
        switch date.month {
        case 2:
            return date.isInLeapYear ? 29 : 28
        case 4, 6, 9:
            return 30
        default:
            return 31
        }
    }
}
