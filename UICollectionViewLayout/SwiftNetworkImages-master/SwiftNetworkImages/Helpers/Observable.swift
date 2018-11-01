//
//  Observable.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

/** Base binding for mutable ViewModels
 
    Sample usage:
 
    ```
    struct ImageViewModel {
        let imageCaption: Observable<String>
    }
    ```
 
    Then to observe changes to the view model from a view:
 
    ```
    imageVewModel.imageCaption.observe { [unowned self] in
        self.captionLabel?.text = $0
    }
    ```
 */
class Observable<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?
    
    func observe(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
    
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
