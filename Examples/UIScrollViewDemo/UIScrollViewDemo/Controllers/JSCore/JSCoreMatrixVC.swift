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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initJS()

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
        callJSFunc(with: "bridgeName") { [weak self] in
            guard let self, let bridgeName = $0?.toString() else { return }
            jsContext?.setObject(self, forKeyedSubscript: (bridgeName as NSString))
        }
    }

    func callJSFunc(with name: String, arguments: [Any] = [], completion: ((JSValue?) -> Void)? = nil) {
        guard let jsFunc = jsContext?.objectForKeyedSubscript(name) else {
            return
        }
        completion?(jsFunc.call(withArguments: arguments))
    }
}

extension JSCoreMatrixVC: SwiftJavaScriptDelegate {
    func sendClientRequest(_ request: [String: Any]) {
        print(request)
    }

    func handleMatrixResponse(_ params: [String: Any]) {
        print(params)
    }
}


@objc
protocol SwiftJavaScriptDelegate: JSExport {

    // js调用App的微信支付功能 演示最基本的用法
    func sendClientRequest(_ request: [String: Any])

    func handleMatrixResponse(_ params: [String: Any])
}
