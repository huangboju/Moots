//
//  HeartRateMonitorViewController.swift
//  Core Bluetooth HRM
//
//  Created by Andrew L. Jaffee on 4/6/18.
//
/*
 
 Copyright (c) 2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

import UIKit

// https://swift.gg/2019/04/15/core-bluetooth/

// STEP 0.00: MUST include the CoreBluetooth framework
import CoreBluetooth

// STEP 0.0: specify GATT "Assigned Numbers" as
// constants so they're readable and updatable

// MARK: - Core Bluetooth service IDs
let BLE_Heart_Rate_Service_CBUUID = CBUUID(string: "0x180D")

// MARK: - Core Bluetooth characteristic IDs
let BLE_Heart_Rate_Measurement_Characteristic_CBUUID = CBUUID(string: "0x2A37")
let BLE_Body_Sensor_Location_Characteristic_CBUUID = CBUUID(string: "0x2A38")

// https://docs.petoi.com/v/chinese/li-cheng/11.-lan-ya-di-gong-hao-ble-chuan-kou-tou-chuan
let RX_SERVICE_UUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
// RX（接收数据）
let RX_CHAR_UUID = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
// TX（发送数据）
let TX_CHAR_UUID = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
let DFU_SERVICE_UUID = CBUUID(string: "0000fe59-0000-1000-8000-00805f9b34fb")

// STEP 0.1: this class adopts both the central and peripheral delegates
// and therefore must conform to these protocols' requirements
class HeartRateMonitorViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: - Core Bluetooth class member variables
    
    // STEP 0.2: create instance variables of the
    // CBCentralManager and CBPeripheral so they
    // persist for the duration of the app's life
    var centralManager: CBCentralManager?
    var peripheralHeartRateMonitor: CBPeripheral?
    
    // MARK: - UI outlets / member variables
    
    @IBOutlet weak var connectingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectionStatusView: UIView!
    @IBOutlet weak var brandNameTextField: UITextField!
    @IBOutlet weak var sensorLocationTextField: UITextField!
    @IBOutlet weak var beatsPerMinuteLabel: UILabel!
    @IBOutlet weak var bluetoothOffLabel: UILabel!
    
    // HealthKit setup
    
    // MARK: - UIViewController delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // initially, we're scanning and not connected
        connectingActivityIndicator.backgroundColor = UIColor.white
        connectingActivityIndicator.startAnimating()
        connectionStatusView.backgroundColor = UIColor.red
        brandNameTextField.text = "----"
        sensorLocationTextField.text = "----"
        beatsPerMinuteLabel.text = "---"
        // just in case Bluetooth is turned off
        bluetoothOffLabel.alpha = 0.0
        
        // STEP 1: create a concurrent background queue for the central
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iosbrain.centralQueueName", attributes: .concurrent)
        // STEP 2: create a central to scan for, connect to,
        // manage, and collect data from peripherals
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
        
        // read heart rate data from HKHealthStore
        // healthKitInterface.readHeartRateData()
        
        // read gender type from HKHealthStore
        // healthKitInterface.readGenderType()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CBCentralManagerDelegate methods

    // STEP 3.1: this method is called based on
    // the device's Bluetooth state; we can ONLY
    // scan for peripherals if Bluetooth is .poweredOn
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        
        case .unknown:
            print("Bluetooth status is UNKNOWN")
            bluetoothOffLabel.alpha = 1.0
        case .resetting:
            print("Bluetooth status is RESETTING")
            bluetoothOffLabel.alpha = 1.0
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
            bluetoothOffLabel.alpha = 1.0
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
            bluetoothOffLabel.alpha = 1.0
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
            bluetoothOffLabel.alpha = 1.0
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            
            DispatchQueue.main.async { () -> Void in
                self.bluetoothOffLabel.alpha = 0.0
                self.connectingActivityIndicator.startAnimating()
            }
            
            // STEP 3.2: scan for peripherals that we're interested in
            centralManager?.scanForPeripherals(withServices: nil)
            
        } // END switch
        
    } // END func centralManagerDidUpdateState
    
    // STEP 4.1: discover what peripheral devices OF INTEREST
    // are available for this app to connect to
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        decodePeripheralState(peripheralState: peripheral.state)
        // STEP 4.2: MUST store a reference to the peripheral in
        // class instance variable
        peripheralHeartRateMonitor = peripheral
        // STEP 4.3: since HeartRateMonitorViewController
        // adopts the CBPeripheralDelegate protocol,
        // the peripheralHeartRateMonitor must set its
        // delegate property to HeartRateMonitorViewController
        // (self)
        peripheralHeartRateMonitor?.delegate = self
        
        // STEP 5: stop scanning to preserve battery life;
        // re-scan if disconnected
        if peripheral.name == "BB18_1_863709FB" {
            centralManager?.stopScan()
            
            // STEP 6: connect to the discovered peripheral of interest
            centralManager?.connect(peripheral)
            
            print("扫描到外设：【UUID: \(peripheral.identifier.uuidString), name: \(peripheral.name ?? "null")】；广播的数据：\(advertisementData)；信号强度：\(RSSI)")
        }
        
    } // END func centralManager(... didDiscover peripheral
    
    // STEP 7: "Invoked when a connection is successfully created with a peripheral."
    // we can only move forwards when we know the connection
    // to the peripheral succeeded
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        DispatchQueue.main.async { () -> Void in
            
            self.brandNameTextField.text = peripheral.name
            self.connectionStatusView.backgroundColor = UIColor.green
            self.beatsPerMinuteLabel.text = "---"
            self.sensorLocationTextField.text = "----"
            self.connectingActivityIndicator.stopAnimating()
            
        }
        
        // STEP 8: look for services of interest on peripheral
        peripheralHeartRateMonitor?.discoverServices([RX_SERVICE_UUID])

    } // END func centralManager(... didConnect peripheral
    
    // STEP 15: when a peripheral disconnects, take
    // use-case-appropriate action
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        // print("Disconnected!")
        
        DispatchQueue.main.async { () -> Void in
            
            self.brandNameTextField.text = "----"
            self.connectionStatusView.backgroundColor = UIColor.red
            self.beatsPerMinuteLabel.text = "---"
            self.sensorLocationTextField.text = "----"
            self.connectingActivityIndicator.startAnimating()
            
        }
        
        // STEP 16: in this use-case, start scanning
        // for the same peripheral or another, as long
        // as they're HRMs, to come back online
        centralManager?.scanForPeripherals(withServices: nil)
        
    } // END func centralManager(... didDisconnectPeripheral peripheral

    // MARK: - CBPeripheralDelegate methods
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            
            print("Service: \(service)")
            
            // STEP 9: look for characteristics of interest
            // within services of interest
            peripheral.discoverCharacteristics([TX_CHAR_UUID], for: service)
            
        }
        
    } // END func peripheral(... didDiscoverServices
    
    // STEP 10: confirm we've discovered characteristics
    // of interest within services of interest
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("characteristic: \(characteristic)")
            
            if characteristic.properties.contains(.notify) || characteristic.properties.contains(.writeWithoutResponse) {
                print(characteristic, "🍀")
            }
            
            
            
            // STEP 11: subscribe to a single notification
            // for characteristic of interest;
            // "When you call this method to read
            // the value of a characteristic, the peripheral
            // calls ... peripheral:didUpdateValueForCharacteristic:error:
            //
            // Read    Mandatory
            //
//            peripheral.readValue(for: characteristic)
            
            peripheral.setNotifyValue(true, for: characteristic)
            

//            if characteristic.uuid == BLE_Heart_Rate_Measurement_Characteristic_CBUUID {
//
//                // STEP 11: subscribe to regular notifications
//                // for characteristic of interest;
//                // "When you enable notifications for the
//                // characteristic’s value, the peripheral calls
//                // ... peripheral(_:didUpdateValueFor:error:)
//                //
//                // Notify    Mandatory
//                //
//                peripheral.setNotifyValue(true, for: characteristic)
//                
//            }
            
        } // END for
        
    } // END func peripheral(... didDiscoverCharacteristicsFor service
    
    func sendGetRecordNumber() {
        let command: [UInt8] = [
            14,
            48
        ]
        let composeByteWithCommand = Data(command).composeByteWithCommand
        print(composeByteWithCommand)
    }
    
    func sendReadWheelSize() {
        let command: [UInt8] = [
            8,
            16
        ]
        let composeByteWithCommand = Data(command).composeByteWithCommand
        print(composeByteWithCommand.hexEncodedString())
    }
    
    // STEP 12: we're notified whenever a characteristic
    // value updates regularly or posts once; read and
    // decipher the characteristic value(s) that we've
    // subscribed to
    var result = Data()
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let data = characteristic.value else {
            return
        }
        print(data.hexEncodedString(), "🍀")
        result.append(data)
        
//        if characteristic.uuid == BLE_Heart_Rate_Measurement_Characteristic_CBUUID {
//            
//            // STEP 13: we generally have to decode BLE
//            // data into human readable format
//            let heartRate = deriveBeatsPerMinute(using: characteristic)
//            
//            DispatchQueue.main.async { () -> Void in
//                
//                UIView.animate(withDuration: 1.0, animations: {
//                    self.beatsPerMinuteLabel.alpha = 1.0
//                    self.beatsPerMinuteLabel.text = String(heartRate)
//                }, completion: { (true) in
//                    self.beatsPerMinuteLabel.alpha = 0.0
//                })
//                
//            } // END DispatchQueue.main.async...
//
//        } // END if characteristic.uuid ==...
//        
//        if characteristic.uuid == BLE_Body_Sensor_Location_Characteristic_CBUUID {
//            
//            // STEP 14: we generally have to decode BLE
//            // data into human readable format
//            let sensorLocation = readSensorLocation(using: characteristic)
//
//            DispatchQueue.main.async { () -> Void in
//                self.sensorLocationTextField.text = sensorLocation
//            }
//        } // END if characteristic.uuid ==...
        
    } // END func peripheral(... didUpdateValueFor characteristic
    
    // MARK: - Utilities
    
    func deriveBeatsPerMinute(using heartRateMeasurementCharacteristic: CBCharacteristic) -> Int {
        
        let heartRateValue = heartRateMeasurementCharacteristic.value!
        // convert to an array of unsigned 8-bit integers
        let buffer = [UInt8](heartRateValue)

        // UInt8: "An 8-bit unsigned integer value type."
        
        // the first byte (8 bits) in the buffer is flags
        // (meta data governing the rest of the packet);
        // if the least significant bit (LSB) is 0,
        // the heart rate (bpm) is UInt8, if LSB is 1, BPM is UInt16
        if ((buffer[0] & 0x01) == 0) {
            // second byte: "Heart Rate Value Format is set to UINT8."
            print("BPM is UInt8")
            // write heart rate to HKHealthStore
            // healthKitInterface.writeHeartRateData(heartRate: Int(buffer[1]))
            return Int(buffer[1])
        } else { // I've never seen this use case, so I'll
                 // leave it to theoroticians to argue
            // 2nd and 3rd bytes: "Heart Rate Value Format is set to UINT16."
            print("BPM is UInt16")
            return -1
        }
        
    } // END func deriveBeatsPerMinute
    
    func readSensorLocation(using sensorLocationCharacteristic: CBCharacteristic) -> String {
        
        let sensorLocationValue = sensorLocationCharacteristic.value!
        // convert to an array of unsigned 8-bit integers
        let buffer = [UInt8](sensorLocationValue)
        var sensorLocation = ""
        
        // look at just 8 bits
        if buffer[0] == 1
        {
            sensorLocation = "Chest"
        }
        else if buffer[0] == 2
        {
            sensorLocation = "Wrist"
        }
        else
        {
            sensorLocation = "N/A"
        }
        
        return sensorLocation
        
    } // END func readSensorLocation
    
    func decodePeripheralState(peripheralState: CBPeripheralState) {
        
        switch peripheralState {
            case .disconnected:
                print("Peripheral state: disconnected")
            case .connected:
                print("Peripheral state: connected")
            case .connecting:
                print("Peripheral state: connecting")
            case .disconnecting:
                print("Peripheral state: disconnecting")
        }
        
    } // END func decodePeripheralState(peripheralState

} // END class HeartRateMonitorViewController

