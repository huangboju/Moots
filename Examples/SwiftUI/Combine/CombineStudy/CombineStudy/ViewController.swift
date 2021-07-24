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

        dataTaskPublisher()
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

