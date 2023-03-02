//
//  Observer.swift
//  UIScrollViewDemo
//
//  Created by bula on 2023/3/2.
//  Copyright © 2023 伯驹 黄. All rights reserved.
//

import Foundation

// 双向绑定
extension NSObjectProtocol where Self: NSObject {
    func observe<A, Other>(_ keyPath: KeyPath<Self, A>, writeTo other: Other, _ otherKeyPath: ReferenceWritableKeyPath<Other, A>) -> NSKeyValueObservation where A: Equatable, Other: NSObjectProtocol {
        return observe(keyPath, options: .new) { _, change in
            guard let newValue = change.newValue,
                other[keyPath: otherKeyPath] != newValue else {
                    return // prevent endless feedback loop
            }
            other[keyPath: otherKeyPath] = newValue
        }
    }
}

extension NSObjectProtocol where Self: NSObject {
    func bind<A, Other>(_ keyPath: ReferenceWritableKeyPath<Self,A>,
                        to other: Other,
                        _ otherKeyPath: ReferenceWritableKeyPath<Other,A>)
        -> (NSKeyValueObservation, NSKeyValueObservation) where A: Equatable, Other: NSObject {
            let one = observe(keyPath, writeTo: other, otherKeyPath)
            let two = other.observe(otherKeyPath, writeTo: self, keyPath)
            return (one,two)
    }
}

protocol Observable {
    associatedtype T: Observer
    mutating func attach(observer: T)
}

protocol Observer {
    associatedtype State

    func notify(_ state: State)
}

struct AnyObservable<T: Observer>: Observable {
    
    var state: T.State {
        didSet {
            notifyStateChange()
        }
    }
    
    var observers: [T] = []
    
    init(_ state: T.State) {
        self.state = state
    }

    mutating func attach(observer: T) {
        observers.append(observer)
        observer.notify(state)
    }
    
    private func notifyStateChange() {
        observers.forEach {
            $0.notify(state)
        }
    }
}

struct AnyObserver<S>: Observer {
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func notify(_ state: S) {
        print("\(name)'s state updated to \(state)")
    }
}

func observable() {
    var observable = AnyObservable<AnyObserver<String>>("hello")
    let observer = AnyObserver<String>(name: "My Observer")
    observable.attach(observer: observer)
    observable.state = "world"
}
