//
//  ViewController.swift
//  CombineStudy
//
//  Created by jourhuang on 2020/9/28.
//

import UIKit
import Combine
import Contacts

fileprivate struct PostmanEchoTimeStampCheckResponse: Decodable, Hashable {
    let valid: Bool
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        dataTaskPublisher()
        combineLatest()
//        merge()
//        zip()
    }
    
    func share() {
        let dataTaskPublisher = URLSession.shared
            .dataTaskPublisher(
                for: URL(string: "https://httpbin.org/get")!)
            .share()
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    enum MyCustomError: Error {
        case custom
    }
    
    // https://zhuanlan.zhihu.com/p/342206085
    func combineLatest() {
        let firstPublisher = PassthroughSubject<Int, MyCustomError>()
        let secondPublisher = PassthroughSubject<String, MyCustomError>()

        firstPublisher
            .combineLatest(secondPublisher)
            .sink(receiveCompletion: { completion in
                print("结束了")
                switch completion {
                case .finished:
                    print("完成")
                case .failure(let error):
                    print("错误：\(error.localizedDescription)")
                }
            }, receiveValue: { someValue in
                print("someValue: \(someValue)")
            })
            .store(in: &cancellables)

        firstPublisher.send(1)
        secondPublisher.send("a")
//        secondPublisher.send(completion: Subscribers.Completion.failure(MyCustomError.custom))
        firstPublisher.send(2)
        secondPublisher.send("b")
    }
    
    func merge() {
        let pub1 = PassthroughSubject<Int, Never>()
        let pub2 = PassthroughSubject<Int, Never>()
        let pub3 = PassthroughSubject<Int, Never>()
        let pub4 = PassthroughSubject<Int, Never>()
        let pub5 = PassthroughSubject<Int, Never>()
        let pub6 = PassthroughSubject<Int, Never>()
        let pub7 = PassthroughSubject<Int, Never>()
        let pub8 = PassthroughSubject<Int, Never>()

        pub1
            .merge(with: pub2, pub3,
                   pub4, pub5,
                   pub6, pub7, pub8)
            .sink(receiveCompletion: { completion in
                print("结束了")
                switch completion {
                case .finished:
                    print("完成")
                case .failure(let error):
                    print("错误：\(error.localizedDescription)")
                }
            }, receiveValue: { someValue in
                print("someValue: \(someValue)")
            })
            .store(in: &cancellables)

        pub1.send(1)
        pub2.send(2)
        pub3.send(3)
        pub4.send(4)
        pub5.send(5)
        pub6.send(6)
        pub7.send(7)
        pub8.send(8)
    }
    
    func zip() {
        let pub1 = PassthroughSubject<Int, Never>()
        let pub2 = PassthroughSubject<Int, Never>()

        pub1
            .zip(pub2)
            .sink(receiveCompletion: { completion in
                print("结束了")
                switch completion {
                case .finished:
                    print("完成")
                case .failure(let error):
                    print("错误：\(error.localizedDescription)")
                }
            }, receiveValue: { someValue in
                print("someValue: \(someValue)")
            })
            .store(in: &cancellables)

        pub1.send(1)
        pub1.send(2)
        pub1.send(3)
        pub2.send(4)
        pub2.send(5)
        pub2.send(1)
    }
    
    func justPubliser() {
        let _ = Just(5)
            .map { value -> String in
                // do something with the incoming value here
                // and return a string
                return "a string"
            }
            .sink { receivedValue in
                // sink is the subscriber and terminates the pipeline
                print("The end result was \(receivedValue)")
            }
    }
    
    func emptyPublisher() {
        let emptyPublisher = Empty<String, Never>()
    }
    
    func futureAsyncPublisher() {
        let futureAsyncPublisher = Future<Bool, Error> { promise in
            CNContactStore().requestAccess(for: .contacts) { grantedAccess, err in
                // err is an optional
                if let err = err {
                    return promise(.failure(err))
                }
                return promise(.success(grantedAccess))
            }
        }.eraseToAnyPublisher()
        
        futureAsyncPublisher.sink { (value) in
            print(value)
        } receiveValue: { (flag) in
            print(flag)
        }
    }
    
    func resolvedSuccessAsPublisher() {
        let resolvedSuccessAsPublisher = Future<Bool, Error> { promise in
            promise(.success(true))
        }.eraseToAnyPublisher()
    }

    func dataTaskPublisher() {
        let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=2016-10-10")
        // checks the validity of a timestamp - this one returns {"valid":true}
        // matching the data structure returned from https://postman-echo.com/time/valid

        let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL!)
            // the dataTaskPublisher output combination is (data: Data, response: URLResponse)
            .map { $0.data }
            .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder())

        let cancellableSink = remoteDataPublisher
            .sink(receiveCompletion: { completion in
                    print(".sink() received the completion", String(describing: completion))
                    switch completion {
                        case .finished:
                            break
                        case .failure(let anError):
                            print("received error: ", anError)
                    }
            }, receiveValue: { someValue in
                print(".sink() received \(someValue)")
            })
    }

}

