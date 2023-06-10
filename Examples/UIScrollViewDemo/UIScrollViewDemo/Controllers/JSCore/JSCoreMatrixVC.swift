//
//  JSCoreMatrixVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2023/6/6.
//  Copyright © 2023 伯驹 黄. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSCoreMatrixVC: UIViewController, RetailSDKJSExport {

    private lazy var jsContext: JSContext? = {
        let jsContext = JSContext()
        jsContext?.exceptionHandler = { context, exception in
            if let ex = exception {
                print("JS exception: " + ex.toString())
            }
        }
        return jsContext
    }()

    private let consoleLog: @convention(block) (Any) -> Void = { logMessage in
        print("\nJS console: ", logMessage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initJS()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "callJS", style: .plain, target: self, action: #selector(callJS))
    }

    @objc
    func callJS() {
        let data: [String: Any] = [
            "artifactPageName": "goods_detail",
            "deepLink": "",
            "basicParams": [
                "appVersion": "1.0.0",
                "deviceId": "123",
                "platform": "iOS",
                "osVersion": "1234",
                "userAgent": "",
                "sessionId": "sessionId",
                "userId": "userId"
            ]
        ]

        callJSFunc(with: "nativeExec", arguments: [data])
    }

    func initJS() {
        guard let path = Bundle.main.path(forResource: "dsmatrix-native.cjs.development", ofType: "js") else {
            return
        }
        do {
            let jsSourceContents = try String(contentsOfFile: path)
            jsContext?.evaluateScript(jsSourceContents)
        } catch let ex {
            print(ex.localizedDescription)
        }

        injectNativeFunction()
    }

    func injectNativeFunction() {
        callJSFunc(with: "bridgeName") { [weak self] in
            guard let self, let bridgeName = $0?.toString() else { return }
            self.jsContext?.setObject(self, forKeyedSubscript: (bridgeName as NSString))
        }

        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        jsContext?.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as NSString)
    }

    func callJSFunc(with name: String, arguments: [Any] = [], completion: ((JSValue?) -> Void)? = nil) {
        guard let jsFunc = jsContext?.objectForKeyedSubscript(name) else {
            return
        }
        let result = jsFunc.call(withArguments: arguments)
        completion?(result)
    }

    // https://stackoverflow.com/questions/35882539/javascriptcore-executing-a-javascript-defined-callback-function-from-native-cod
    func sendClientRequest(_ request: JSValue) {
        print(request.toDictionary())
        guard let urlLink = request.forProperty("url").toString(),
              let url = URL(string: urlLink),
              let method = request.forProperty("type").toString(),
              let data = request.toDictionary()["data"] as? [String: Any] else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            let success = request.forProperty("success")
            success?.call(withArguments: ["参数"])

            let failt = request.forProperty("fail")
            failt?.call(withArguments: nil)
        }
    }

    func handleMatrixResponse(_ params: JSValue) {
        print(params, #function)
    }

    func consoleLog(_ content: JSValue) {
        print("🍀\nJS console: ", content.toString())
    }
}

@objc
protocol RetailSDKJSExport: JSExport {

    // js调用App的微信支付功能 演示最基本的用法
    func sendClientRequest(_ request: JSValue)

    func handleMatrixResponse(_ params: JSValue)

    func consoleLog(_ content: JSValue)
}
