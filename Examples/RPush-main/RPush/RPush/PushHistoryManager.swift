//
//  PushHistoryManager.swift
//  RPush
//

import Foundation

class PushHistoryManager {
    
    static let shared = PushHistoryManager()
    
    private let historyKey = "KEY_PUSH_HISTORY"
    private let maxRecords = 100
    
    private init() {}
    
    var records: [PushHistoryRecord] {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return []
        }
        let decoded = (try? JSONDecoder().decode([PushHistoryRecord].self, from: data)) ?? []
        return decoded.sorted { $0.date > $1.date }
    }
    
    func addRecord(_ record: PushHistoryRecord) {
        var list = records
        list.insert(record, at: 0)
        if list.count > maxRecords {
            list = Array(list.prefix(maxRecords))
        }
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
    
    func removeRecord(at index: Int) {
        var list = records
        guard index >= 0 && index < list.count else { return }
        list.remove(at: index)
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
    
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
}
