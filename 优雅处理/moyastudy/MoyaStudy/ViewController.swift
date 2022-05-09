//
//  ViewController.swift
//  MoyaStudy
//
//  Created by fancy on 2017/4/13.
//  Copyright © 2017年 fancy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var viewModel = ViewModelExample()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequestExample()
        
//        postRequestExample()
        
//        uploadImageExample()
    }

}

// network example 
extension ViewController {
    
    func getRequestExample() {
        viewModel.getHomepagePageData().then { data in
            // fetch data to refresh UI
            print(data.msg ?? "")
        }.always {
            // optional
            // always do something before request complete,such as cache data,etc.
            print("request complete")
        }.catch { (error) in
            // handle error
            print(error)
        }
    }
    
    func postRequestExample() {
        viewModel.fetchMorePackageArts(count: 1, artStyleId: 1, artType: 1).then {
            // use $+0,1,2,3 to stand for parameter 1, parameter 2, parameter 3
            print($0.count)
        }.catch {
            print($0)
        }
    }
    
    // this function is a simple example and never request success,just study how to write it
    func uploadImageExample() {
        viewModel.upload(image: UIImage(named: "miku")!, otherParameter: "image name").then {
            print($0)
        }.catch {
            print($0)
        }
    }
    
}




