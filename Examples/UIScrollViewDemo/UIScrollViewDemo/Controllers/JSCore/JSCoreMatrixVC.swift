//
//  JSCoreMatrixVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2023/6/6.
//  Copyright © 2023 伯驹 黄. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSCoreMatrixVC: UIViewController {

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

    private let _sendClientRequest: @convention(block) ([String: Any]) -> Void = {
        sendClientRequest($0)
    }

    private let _handleMatrixResponse: @convention(block) ([String: Any]) -> Void = {
        handleMatrixResponse($0)
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
            "deepLink": "www.youtube.com",
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
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        jsContext?.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        jsContext?.evaluateScript("consoleLog")

        let request = unsafeBitCast(_sendClientRequest, to: AnyObject.self)
        jsContext?.setObject(request, forKeyedSubscript: "sendClientRequest" as (NSCopying & NSObjectProtocol))
        jsContext?.evaluateScript("sendClientRequest")

        let response = unsafeBitCast(_handleMatrixResponse, to: AnyObject.self)
        jsContext?.setObject(response, forKeyedSubscript: "handleMatrixResponse" as (NSCopying & NSObjectProtocol))
        jsContext?.evaluateScript("handleMatrixResponse")

        callJSFunc(with: "bridgeName") { [weak self] in
            guard let self, let bridgeName = $0?.toString() else { return }
            jsContext?.setObject(self, forKeyedSubscript: (bridgeName as NSString))
        }
    }

    func callJSFunc(with name: String, arguments: [Any] = [], completion: ((JSValue?) -> Void)? = nil) {
        guard let jsFunc = jsContext?.objectForKeyedSubscript(name) else {
            return
        }
        let result = jsFunc.call(withArguments: arguments)
        completion?(result)
    }

    func sendClientRequest(_ request: [String: Any]) {
        print(request, #function)
    }

    func handleMatrixResponse(_ params: [String: Any]) {
        print(params, #function)
    }
}
