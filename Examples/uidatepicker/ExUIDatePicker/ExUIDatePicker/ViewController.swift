//
//  ViewController.swift
//  ExUIDatePicker
//
//  Created by joe feng on 2016/5/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    var datePicker: UIDatePicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        // 設置 UIDatePicker 格式
        datePicker.datePickerMode = .dateAndTime
        
        // 選取時間時的分鐘間隔 這邊以 15 分鐘為一個間隔
        datePicker.minuteInterval = 15

        // 設置預設時間為現在時間
        datePicker.date = Date()
        
        // 設置 Date 的格式
        let formatter = DateFormatter()
        
        // 設置時間顯示的格式
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // 可以選擇的最早日期時間
        let fromDateTime = formatter.date(from: "2016-01-02 18:08")
        
        // 設置可以選擇的最早日期時間
        datePicker.minimumDate = fromDateTime
        
        // 可以選擇的最晚日期時間
        let endDateTime = formatter.date(from: "2017-12-25 10:45")
        
        // 設置可以選擇的最晚日期時間
        datePicker.maximumDate = endDateTime

        // 設置顯示的語言環境
        datePicker.locale = Locale(identifier: "zh_TW")
        
        // 設置改變日期時間時會執行動作的方法
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }

    func datePickerChanged(_ datePicker: UIDatePicker) {
        print(datePicker, #function)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var canBecomeFirstResponder: Bool {
        return datePicker.window == nil
    }

    override var inputView: UIView? {
        return datePicker
    }

    override var inputAccessoryView: UIView? {
        let accessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        accessoryView.backgroundColor = UIColor.white
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let right = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        accessoryView.items = [flexible, right]
        return accessoryView
    }

    func doneAction() {
        resignFirstResponder()
    }
}

class ViewController: UIViewController {
    
    var datePickerView: DatePickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        datePickerView = DatePickerView(frame: view.frame.insetBy(dx: 50, dy: 100))
        datePickerView.backgroundColor = UIColor.red
        view.addSubview(datePickerView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        datePickerView.becomeFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

