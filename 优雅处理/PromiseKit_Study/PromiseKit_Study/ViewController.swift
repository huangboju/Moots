//
//  ViewController.swift
//  PromiseKit_Study
//
//  Created by 伯驹 黄 on 2017/5/18.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

// https://blog.dianqk.org/2016/08/22/rxswift-vs-promisekit/

// http://promisekit.org/docs/

// https://www.raywenderlich.com/145683/getting-started-promises-promisekit


// http://swift.gg/2017/05/04/common-patterns-with-promises/

// http://swift.gg/2017/03/27/promises-in-swift/

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        threeRequest().ensure {
            print("完成啦")
        }.catch {
            print($0)
        }


//        firstly {
//          loginPromise()
//        }.then { dict in
//            print(dict)
//        }.then {
//            print("then")
//        }.always {
//            print("aaaa")
//        }
    
        sessionTest()
    }

    func request(with parameters: [String: Any]) -> Promise<NSDictionary> {
        return Promise { seal in
            Alamofire.request("https://httpbin.org/get", method: .get, parameters: parameters).validate().responseJSON() { (response) in
                switch response.result {
                case .success(let dict):
                    seal.fulfill(dict as! NSDictionary)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func threeRequest() -> Promise<()> {
        return firstly {
                request(with: ["test1": "first"])
            }.then { (v) -> Promise<NSDictionary> in
                print("🍀", v)
                return self.request(with: ["test2": "second"])
            }.then { (v) -> Promise<NSDictionary> in
                print("🍀🍀", v)
                return self.request(with: ["test3": "third"])
            }.done { (v) in
                print("🍀🍀🍀", v)
            }
    }

    func afterTest() {
        after(seconds: 1.5).done {
            
        }
    }
    
    func raceTest() {
        firstly {
            race(loginPromise(), loginPromise())
        }.done {
            print($0)
        }.catch {
            print($0)
        }
    }

    func whenTest() {
        firstly {
            when(fulfilled: sessionPromise(), loginPromise())
        }.done { result1, result2 in
            print(result1, result2)
        }.catch {
            print($0)
        }
    }

    let url = URL(string: "http://www.tngou.net/api/area/province")!

    func AlamofireWithPromise() {
        firstly {
            Alamofire.request(url, method: .get, parameters: ["type": "all"]).responseJSON()
        }.done { result1 in
            print(result1)
        }.catch {
            print($0)
        }
    }

    func loginPromise() -> Promise<NSDictionary> {
        return Promise { seal in
            Alamofire.request("https://httpbin.org/get", method: .get, parameters: ["foo": "bar"]).validate().responseJSON() { (response) in
                switch response.result {
                case .success(let dict):
                    seal.fulfill(dict as! NSDictionary)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func sessionTest() {
        firstly {
            sessionPromise()
        }.then(on: .global()) { data -> Promise<[String: Any]> in
            print("global queue", Thread.current)
            return Promise<[String: Any]> { seal in
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        seal.fulfill(json as! [String : Any])
                } catch {
                        seal.reject(error)
                }
            }
        }.ensure {
            print("1111", Thread.current)
        }.done { json in
            print(json, Thread.current)
        }.ensure {
            
        }.catch {
            print($0)
        }
    }

    func sessionPromise() -> Promise<Data> {
        return URLSession.shared.promise(URL(string: "https://httpbin.org/get?foo=bar")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension URLSession {
    func promise(_ url: URL) -> Promise<Data> {
        return Promise<Data> { seal in
            dataTask(with: url) { (data, _, error) in
                if let data = data {
                    seal.fulfill(data)
                } else if let error = error {
                    seal.reject(error)
                }
            }.resume()
        }
    }
}


