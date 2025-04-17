//
//  MiBandService.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/12/12.
//

import Foundation
import CoreBluetooth

/// Mi Band 관련 BLE Service 및 Characteristic UUID, 명령어 정의
struct MiBandService {
    
    // MARK: - Services
    static let UUID_SERVICE_MIBAND_SERVICE = CBUUID(string: "FEE0")
    static let UUID_SERVICE_HEART_RATE = CBUUID(string: "180D")
    static let UUID_SERVICE_ALERT = CBUUID(string: "1802")
    
    // MARK: - Characteristics
    static let UUID_CHARACTERISTIC_FIRMWARE = CBUUID(string: "00001531-0000-3512-2118-0009af100700")
    static let UUID_CHARACTERISTIC_FIRMWARE_DATA = CBUUID(string: "00001532-0000-3512-2118-0009af100700")
    static let UUID_CHARACTERISTIC_HEART_RATE_CONTROL = CBUUID(string: "2A39")
    static let UUID_CHARACTERISTIC_HEART_RATE_DATA = CBUUID(string: "2A37")
    static let UUID_CHARACTERISTIC_VIBRATION_CONTROL = CBUUID(string: "2A06")
    
    static let UUID_CHARACTERISTIC_CONFIGURATION = CBUUID(string: "00000003-0000-3512-2118-0009af100700")
    static let UUID_CHARACTERISTIC_ACTIVITY_DATA = CBUUID(string: "00000005-0000-3512-2118-0009af100700")
    static let UUID_CHARACTERISTIC_BATTERY_INFO = CBUUID(string: "00000006-0000-3512-2118-0009af100700")
    static let UUID_CHARACTERISTIC_REALTIME_STEPS = CBUUID(string: "00000007-0000-3512-2118-0009af100700")
    static let UUID_CHARACTERISTIC_AUTH = CBUUID(string: "00000009-0000-3512-2118-0009af100700")
    static let UUID_CHARACTERISTIC_BUTTON = CBUUID(string: "00000010-0000-3512-2118-0009af100700")
    
    // MARK: - Vibration Commands
    static let ALERT_LEVEL_CUSTOM: [Int8] = [-1, 2, 2, 1, 1, 3]
    static let ALERT_LEVEL_NONE: [Int8] = [0]
    static let ALERT_LEVEL_MESSAGE: [Int8] = [1]
    static let ALERT_LEVEL_PHONE_CALL: [Int8] = [2]
    static let ALERT_LEVEL_VIBRATE_ONLY: [Int8] = [3]
    
    // MARK: - Heart Rate Commands
    static let COMMAND_START_HEART_RATE_MEASUREMENT: [UInt8] = [21, 2, 1]
}
