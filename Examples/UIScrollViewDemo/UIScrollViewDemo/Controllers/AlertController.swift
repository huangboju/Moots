//
//  ViewController.swift
//  AlertController
//
//  Created by 伯驹 黄 on 2016/10/10.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

/// 一个排序断言，当第一个值应当排在第二个值之前时，返回 `true`
typealias SortDescriptor<Root> = (Root, Root) -> Bool

@objcMembers
final class Person: NSObject {
    let first: String
    let last: String
    let yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
        // super.init() 在这里被隐式调用
    }
}

struct Address {
    var street: String
    var city: String
    var zipCode: Int
}

struct House {
    let name: String
    var address: Address
}

class AlertController: UIViewController {
    
    func sort() {
        let people = [
        Person(first: "Emily", last: "Young", yearOfBirth: 2002),
        Person(first: "David", last: "Gray", yearOfBirth: 1991),
        Person(first: "Robert", last: "Barnes", yearOfBirth: 1985),
        Person(first: "Ava", last: "Barnes", yearOfBirth: 2000),
        Person(first: "Joanne", last: "Miller", yearOfBirth: 1994),
        Person(first: "Ava", last: "Barnes", yearOfBirth: 1998),
        ]
        
        let sortByYear: SortDescriptor<Person> = { $0.yearOfBirth < $1.yearOfBirth }
        print(people.sorted(by: sortByYear))
        let sortByLastName: SortDescriptor<Person> = { $0.last.localizedStandardCompare($1.last) == .orderedAscending }
        print(people.sorted(by: sortByLastName))
        
        let sortByYearAlt: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth }, by: <)
        print(people.sorted(by: sortByYearAlt))
        
        let sortByYearAlt2: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth })
        print(people.sorted(by: sortByYearAlt2))
        
        
        let sortByFirstName: SortDescriptor<Person> = sortDescriptor(key: { $0.first }, by: String.localizedStandardCompare)
        print(people.sorted(by: sortByFirstName))
        
        let combined: SortDescriptor<Person> = combine(sortDescriptors: [sortByLastName, sortByFirstName, sortByYear])
        print(people.sorted(by: combined))
        
//        let compare = lift(String.localizedStandardCompare)
//        let result = files.sorted(by: sortDescriptor(key: { $0.fileExtension }, by: compare))
    }

    /// `by` 进行比较的断言
    /// 通过用 `by` 比较 `key` 返回值的方式构建 `SortDescriptor` 函数
    func sortDescriptor<Root, Value>(key: @escaping (Root) -> Value, by areInIncreasingOrder: @escaping (Value, Value) -> Bool) -> SortDescriptor<Root> {
        return { areInIncreasingOrder(key($0), key($1)) }
    }
    
    func sortDescriptor<Root, Value>(key: @escaping (Root) -> Value) -> SortDescriptor<Root> where Value: Comparable {
        return { key($0) < key($1) }
    }
    
    func sortDescriptor<Root, Value>(key: @escaping (Root) -> Value, ascending: Bool = true, by comparator: @escaping (Value) -> (Value) -> ComparisonResult) -> SortDescriptor<Root> {
    return { lhs, rhs in
        let order: ComparisonResult = ascending
            ? .orderedAscending
            : .orderedDescending
        return comparator(key(lhs))(key(rhs)) == order
        }
    }
    
    func combine<Root>(sortDescriptors: [SortDescriptor<Root>]) -> SortDescriptor<Root> {
        return { lhs, rhs in
            for areInIncreasingOrder in sortDescriptors {
                if areInIncreasingOrder(lhs, rhs) { return true }
                if areInIncreasingOrder(rhs, lhs) { return false }
            }
            return false
        }
    }
    
    func lift<A>(_ compare: @escaping (A) -> (A) -> ComparisonResult) -> (A?) -> (A?) -> ComparisonResult {
        return { lhs in { rhs in
                switch (lhs, rhs) {
                case (nil, nil): return .orderedSame
                case (nil, _): return .orderedAscending
                case (_, nil): return .orderedDescending
                case let (l?, r?): return compare(l)(r)
                }
            }
        }
    }
    
    func keyPaths() {
        let streetKeyPath = \House.address.street
        // Swift.WritableKeyPath<Person, Swift.String>
        let nameKeyPath = \House.name // Swift.KeyPath<Person, Swift.String>”
        
        let simpsonResidence = Address(street: "1094 Evergreen Terrace",
        city: "Springfield", zipCode: 97475)
        var lisa = House(name: "Lisa Simpson", address: simpsonResidence)
        print(lisa[keyPath: nameKeyPath])
        lisa[keyPath: streetKeyPath] = "742 Evergreen Terrace"
        print(lisa[keyPath: streetKeyPath])
    }
    
    func bind() {
        let animal = Animal()
        let textField = TextField()
        let observation = animal.bind(\.name, to: textField, \.text)
        animal.name = "John"
        print(textField.text)
        textField.text = "Sarah"
        print(animal.name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button = UIButton(frame: view.frame.insetBy(dx: 100, dy: 200))
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.backgroundColor = .green
        view.addSubview(button)
        
//        sort()
//        bind()
        
        keyPaths()
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }

    @objc func action() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { _ in
        }
        alertController.addAction(ok)

        let image = UIImage(named: "ic_attachment")
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)

        let alertControllerTitleStr = NSMutableAttributedString(string: "测试")
        
        alertControllerTitleStr.append(NSAttributedString(attachment: attachment))
        
        alertControllerTitleStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: 0, length: 2))
        
        
        
        let alertControllerMessageStr = NSMutableAttributedString(string: "今天天气好晴朗")

        alertControllerMessageStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 4))
        
        alertController.setValue(alertControllerMessageStr, forKey: "attributedMessage")

        ok.setValue(UIColor.red, forKey: "titleTextColor")

        present(alertController, animated: true) {
        }

        alertController.setValue(alertControllerTitleStr, forKey: "attributedTitle")
    }
}

final class Animal: NSObject {
    @objc dynamic var name: String = ""
}

class TextField: NSObject {
    @objc dynamic var text: String = ""
}

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

