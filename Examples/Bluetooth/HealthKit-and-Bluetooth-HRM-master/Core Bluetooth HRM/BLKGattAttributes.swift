//
//  BLKGattAttributes.swift
//  Core Bluetooth HRM
//
//  Created by 黄伯驹 on 2024/4/4.
//  Copyright © 2024 Andrew Jaffee. All rights reserved.
//

import Foundation

public class BLKGattAttributes {
    
    static let shared = BLKGattAttributes()
    
    public static let APPEARANCE = "00002a01-0000-1000-8000-00805f9b34fb"
    public static let BATTERY_LEVEL = "00002a19-0000-1000-8000-00805f9b34fb"
    public static let BATTERY_SERVICE = "0000180f-0000-1000-8000-00805f9b34fb"
    public static let CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
    public static let CSC_MEASUREMENT = "00002a5b-0000-1000-8000-00805f9b34fb"
    public static let CYCLING_POWER = "00001818-0000-1000-8000-00805f9b34fb"
    public static let CYCLING_SPEED_AND_CADENCE = "00001816-0000-1000-8000-00805f9b34fb"
    public static let DEVICE_INFORMATION_SERVICE = "0000180a-0000-1000-8000-00805f9b34fb"
    public static let DEVICE_NAME = "00002a00-0000-1000-8000-00805f9b34fb"
    public static let FITNESS_DEVICE_INFO = "0000180A-0000-1000-8000-00805f9b34fb"
    public static let FITNESS_FIRMWARE_REVISION = "00002A26-0000-1000-8000-00805f9b34fb"
    public static let FITNESS_MACHINE = "00001826-0000-1000-8000-00805f9b34fb"
    public static let FITNESS_MACHINE_CONTROL_POINT = "00002AD9-0000-1000-8000-00805f9b34fb"
    public static let FITNESS_MACHINE_INDOOR_BIKE = "00002AD2-0000-1000-8000-00805f9b34fb"
    public static let GENERIC_ACCESS = "00001800-0000-1000-8000-00805f9b34fb"
    public static let GENERIC_ATTRIBUTE = "00001801-0000-1000-8000-00805f9b34fb"
    public static let HEART_RATE = "0000180d-0000-1000-8000-00805f9b34fb"
    public static let HEART_RATE_MEASUREMENT = "00002a37-0000-1000-8000-00805f9b34fb"
    public static let HEART_RATE_SERVICE = "0000fff00000-1000-8000-00805f9b34fb"
    public static let HEART_VALUE_NOTIFY = "0000fd09-0000-1000-8000-00805f9b34fb"
    public static let HEART_VALUE_WRITE = "0000fd0a-0000-1000-8000-00805f9b34fb"
    public static let POWER_MEASUREMENT = "00002a63-0000-1000-8000-00805f9b34fb"
    public static let SECURE_DFU_SERVICE = "0000FE59-0000-1000-8000-00805f9b34fb"
    public static let SECURE_DFU_SERVICE_BUTTONLESS = "8ec90003-f315-4f60-9fb8-838830daea50"

    public static func lookup(str: String, str2: String) -> String {
        return shared.attributes[str] ?? str2
    }
    
    private lazy var attributes: [String: String] = {
        let attributes = [
            BLKGattAttributes.HEART_RATE_SERVICE: "Heart Rate Service",
            BLKGattAttributes.GENERIC_ACCESS: "Generic Access",
            BLKGattAttributes.GENERIC_ATTRIBUTE: "Generic Attribute",
            BLKGattAttributes.CSC_MEASUREMENT: "00002a5b-0000-1000-8000-00805f9b34fb",
            BLKGattAttributes.DEVICE_INFORMATION_SERVICE: "Device Information Service",
            BLKGattAttributes.CYCLING_SPEED_AND_CADENCE: "Cycling Speed and Cadence",
            BLKGattAttributes.HEART_RATE: "Heart Rate",
            BLKGattAttributes.BATTERY_SERVICE: "Battery Service",
            BLKGattAttributes.HEART_RATE_MEASUREMENT: "Heart Rate Measurement",
            BLKGattAttributes.BATTERY_LEVEL: "Battery Level",
            BLKGattAttributes.DEVICE_NAME: "Device Name",
            BLKGattAttributes.APPEARANCE: "Appearance",
            "00002a02-0000-1000-8000-00805f9b34fb": "Peripheral Privacy Flag",
            "00002a03-0000-1000-8000-00805f9b34fb": "Reconnection Address",
            "00002a04-0000-1000-8000-00805f9b34fb": "Peripheral Preferred",
            "00002a05-0000-1000-8000-00805f9b34fb": "Service Changed",
            "00002a23-0000-1000-8000-00805f9b34fb": "System ID",
            "00002a24-0000-1000-8000-00805f9b34fb": "Model Number String",
            "00002a25-0000-1000-8000-00805f9b34fb": "Serial Number String",
            "00002a26-0000-1000-8000-00805f9b34fb": "Firmware Revision String",
            "00002a27-0000-1000-8000-00805f9b34fb": "Hardware Revision String",
            "00002a28-0000-1000-8000-00805f9b34fb": "Software Revision String",
            "00002a29-0000-1000-8000-00805f9b34fb": "Manufacturer Name String",
            "00002a2a-0000-1000-8000-00805f9b34fb": "IEEE 11073-20601 Regulatory",
            "00002a38-0000-1000-8000-00805f9b34fb": "Body Sensor Location",
            "00002a39-0000-1000-8000-00805f9b34fb": "Heart Rate Control Point"
        ]
        return attributes
    }()
}
