//
//  UUIDKey.swift
//  Basic Chat
//
//  Created by Trevor Beaton on 12/3/16.
//  Copyright © 2016 Vanguard Logic LLC. All rights reserved.
//

import CoreBluetooth
//Uart Service uuid


let RX_SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
let RX_CHAR_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
let TX_CHAR_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
let MaxCharacters = 20

let BLEService_UUID = CBUUID(string: RX_SERVICE_UUID)
let BLE_Characteristic_uuid_Tx = CBUUID(string: TX_CHAR_UUID)//(Property = Write without response)
let BLE_Characteristic_uuid_Rx = CBUUID(string: RX_CHAR_UUID)// (Property = Read/Notify)
