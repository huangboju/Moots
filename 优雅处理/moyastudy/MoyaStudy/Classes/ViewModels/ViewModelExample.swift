//
//  ViewModelExample.swift
//  MoyaStudy
//
//  Created by fancy on 2017/4/13.
//  Copyright © 2017年 fancy. All rights reserved.
//

import RxSwift
import Moya
import PromiseKit

class ViewModelExample {
    private let disposeBag = DisposeBag()
    private let provider = RxMoyaProvider<ApiExample>(plugins: [RequestLoadingPlugin(),NetworkLogger()])

    // 实例1:直接解析model
    func getHomepagePageData() -> Promise<HomepageData> {
        return Promise(resolvers: { (result, error) in
            provider.request(.frontpage)
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .mapObject(type: HomepageData.self)
                .subscribe(onNext: {
                    result($0)
                }, onError: {
                    error($0)
                })
                .addDisposableTo(disposeBag)
        })
    }

    // 实例2:解析response里的某个key为model
    func fetchMorePackageArts(count: Int, artStyleId: Int, artType: Int) -> Promise<[Art]> {
        return Promise(resolvers: { (result, error) in
            provider.request(.fetchMorePackageArts(count: count, artStyleId: artStyleId, artType: artType))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .mapArray(type: Art.self, key: "works")
                .subscribe(onNext: {
                    result($0)
                }, onError: {
                    error($0)
                })
                .addDisposableTo(disposeBag)
        })
    }
    
    // 实例3:上传图片
    func upload(image: UIImage, otherParameter: String) -> Promise<Int> {
        return Promise(resolvers: { (result, error) in
            provider.request(.updateExample(image: image, otherParameter: otherParameter))
                    .filterSuccessfulStatusCodes()
                    .mapJSON()
                    .parseServerError()
                    .subscribe(onNext: { (json) in
                        // 此处是我随便返回的
                        result(200)
                    }, onError: { (err) in
                        error(err)
                    })
                    .addDisposableTo(disposeBag)
        })
    }

}










