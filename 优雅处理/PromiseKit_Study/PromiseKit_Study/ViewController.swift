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

//        threeRequest().always {
//            print("完成啦")
//        }


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
        return Promise { fulfill, reject in
            Alamofire.request("https://httpbin.org/get", method: .get, parameters: parameters).validate().responseJSON() { (response) in
                switch response.result {
                case .success(let dict):
                    fulfill(dict as! NSDictionary)
                case .failure(let error):
                    reject(error)
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
            }.then { (v) in
                print("🍀🍀🍀", v)
            }.catch { (error) in
                print(error)
            }
    }

    func afterTest() {
//        after(interval: 1.5).then { _ in
//            // 1.5 seconds later!
//        }
    }
    
    func raceTest() {
        race(loginPromise(), loginPromise()).then { winner in
             print(winner)
        }.catch { error in
            print(error)
        }
    }

    func whenTest() {
        when(fulfilled: sessionPromise(), loginPromise()).then { (data, dict) in
            print(data, dict)
        }.catch { (error) in
            
        }
    }

    let url = URL(string: "http://www.tngou.net/api/area/province")!

    func AlamofireWithPromise() {
        Alamofire.request(url, method: .get, parameters: ["type": "all"]).responseJSON().then { (result) in
            print(result)
        }.catch { (error) in
                print(error)
        }
    }

    func loginPromise() -> Promise<NSDictionary> {
        return Promise { fulfill, reject in
            Alamofire.request("https://httpbin.org/get", method: .get, parameters: ["foo": "bar"]).validate().responseJSON() { (response) in
                switch response.result {
                case .success(let dict):
                    fulfill(dict as! NSDictionary)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }

    func sessionTest() {
        firstly {
            sessionPromise()
        }.then(on: DispatchQueue.global()) { data -> Promise<[String: Any]> in
            print("global queue", Thread.current)
            return Promise<[String: Any]> { (fulfill, reject) in
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        fulfill(json as! [String : Any])
                } catch {
                        reject(error)
                }
            }
        }.always {
            print("1111", Thread.current)
        }.then { (json) in
            print(json, Thread.current)
        }.always {
            print("always", Thread.current)
        }.catch { (error) in
            print(error)
        }.always {
            print("😁")
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
        return Promise<Data> { (fulfill, reject) in
            dataTask(with: url) { (data, _, error) in
                if let data = data {
                    fulfill(data)
                } else if let error = error {
                    reject(error)
                }
            }.resume()
        }
    }
}


