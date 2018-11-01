//
//  ViewController.swift
//  ExUIDatePicker
//
//  Created by joe feng on 2016/5/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    private var datePicker: UIDatePicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        // 設置 UIDatePicker 格式
        datePicker.datePickerMode = .date
        
        // 選取時間時的分鐘間隔 這邊以 15 分鐘為一個間隔
        datePicker.minuteInterval = 15

        // 設置預設時間為現在時間
        datePicker.date = Date()

        // 設置 Date 的格式
        let formatter = DateFormatter()
        
        // 設置時間顯示的格式
        formatter.dateFormat = "yyyy-MM-dd"

        // 可以選擇的最早日期時間
        let fromDateTime = formatter.date(from: "1990-01-01")

        // 設置可以選擇的最早日期時間
        datePicker.minimumDate = fromDateTime

        // 可以選擇的最晚日期時間
        let endDateTime = formatter.date(from: "2027-12-31")

        // 設置可以選擇的最晚日期時間
        datePicker.maximumDate = endDateTime


        // 設置顯示的語言環境
        datePicker.locale = Locale(identifier: "zh_TW")
        
        // 設置改變日期時間時會執行動作的方法
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }

    @objc func datePickerChanged(_ datePicker: UIDatePicker) {
        print(datePicker.date, #function)
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

    @objc func doneAction() {
        resignFirstResponder()
    }
}


class ClassPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    var pickerView: UIPickerView!
    
    var items: [[String]] = [
        [
            "一",
            "二",
            "三",
            "四"
        ],
        [
            "1",
            "2"
        ]
    ]
    
    let dict: [String: [String]] = [
        "一": ["1", "2"],
        "二": [ "1", "2", "3"],
        "三": [ "1", "2", "3", "4"],
        "四": [ "1"]
    ]

    let gradeTextLabel = UILabel()
    let classTextLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        pickerView.delegate = self
        pickerView.dataSource = self

        // 23 = 9 * 2 + 5
        let w = (pickerView.frame.width - 23) / 4

        gradeTextLabel.frame = CGRect(x: w + 25, y: 0, width: 80, height: 30)
        gradeTextLabel.text = "年级"
        gradeTextLabel.font = UIFont.systemFont(ofSize: 23.5)
        pickerView.addSubview(gradeTextLabel)

        gradeTextLabel.center.y = pickerView.center.y

        classTextLabel.frame = CGRect(x: pickerView.frame.width - w + 9, y: 0, width: 40, height: 30)
        classTextLabel.text = "班"
        classTextLabel.font = UIFont.systemFont(ofSize: 23.5)
        pickerView.addSubview(classTextLabel)
        
        classTextLabel.center.y = pickerView.center.y
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 { return }
        items[1] = dict[items[0][row]]!
        pickerView.reloadComponent(1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var canBecomeFirstResponder: Bool {
        return pickerView.window == nil
    }

    override var inputView: UIView? {
        return pickerView
    }

    override var inputAccessoryView: UIView? {
        let accessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        accessoryView.backgroundColor = UIColor.white
        let cancel = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(doneAction))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let right = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneAction))
        accessoryView.items = [cancel, fixedSpace, right]
        return accessoryView
    }

    @objc func doneAction() {
        resignFirstResponder()
    }
}

class ViewController: UIViewController {
    
    var classPickerView: ClassPickerView!
    
    var datePickerView: DatePickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        classPickerView = ClassPickerView(frame: CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 44))
        classPickerView.backgroundColor = UIColor.red
        view.addSubview(classPickerView)


        datePickerView = DatePickerView(frame: CGRect(x: 16, y: 160, width: view.frame.width - 32, height: 44))
        datePickerView.backgroundColor = UIColor.blue
        view.addSubview(datePickerView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        classPickerView.becomeFirstResponder()

        datePickerView.becomeFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

