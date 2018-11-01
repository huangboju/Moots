//
//  SortedDictionary.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

/// Sorted Dictionary implemetation
/// Uses binary search for inserting keys in sorted order

struct SortedDictionary<K, V> where K: Hashable, K: Comparable {
    private var _dict: Dictionary<K, V> = [:]
    private var _sortedKeys: [K] = []
    
    var sortedKeys: [K] {
        return _sortedKeys
    }
    
    var count: Int {
        return _sortedKeys.count
    }
    
    subscript(key: K) -> V? {
        get {
            return _dict[key]
        }
        set(newValue) {
            if !_sortedKeys.contains(key) {
                let idx = _sortedKeys.binarySearch{ $0 < key }
                _sortedKeys.insert(key, at: idx)
            }
            _dict[key] = newValue
        }
    }
    
    func valueForKeyAtIndex(index: Int) -> V? {
        guard _sortedKeys.count > index else {return nil}
        return _dict[_sortedKeys[index]]
    }
}


