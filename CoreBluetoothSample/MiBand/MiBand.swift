//
//  MiBand.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/12/12.
//

import Foundation
import CoreBluetooth

/// Mi Band 디바이스와의 통신을 담당하는 헬퍼 클래스
final class MiBand {
    
    // MARK: - Properties
    let peripheral: CBPeripheral
    
    // MARK: - Initialization
    init(_ peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    // MARK: - Public Methods
    
    /// Mi Band를 진동 시작
    func startVibrate() {
        sendVibrationCommand(MiBandService.ALERT_LEVEL_VIBRATE_ONLY)
    }
    
    /// Mi Band 진동 중지
    func stopVibrate() {
        sendVibrationCommand(MiBandService.ALERT_LEVEL_NONE)
    }
    
    /// 배터리 데이터에서 충전 퍼센트 추출
    func getBattery(batteryData: Data) -> Int {
        print("--- Updating Battery Data ---")
        
        let buffer = [UInt8](batteryData)
        guard buffer.indices.contains(1) else { return 0 }
        
        let batteryLevel = Int(buffer[1])
        print("\(batteryLevel)% charged")
        
        return batteryLevel
    }
    
    /// 현재 걸음수, 거리, 칼로리 정보 가져오기
    func getSteps() -> (steps: Int, distance: Int, calories: Int)? {
        guard
            let service = peripheral.services?.first(where: { $0.uuid == MiBandService.UUID_SERVICE_MIBAND_SERVICE }),
            let characteristic = service.characteristics?.first(where: { $0.uuid == MiBandService.UUID_CHARACTERISTIC_REALTIME_STEPS }),
            let data = characteristic.value
        else {
            print("Steps Characteristic or Service not found")
            return nil
        }
        
        print("--- Updating Steps Data ---")
        let buffer = [UInt8](data)
        
        guard buffer.count >= 13 else { return nil }
        
        let steps = Int(UInt16(buffer[1]) | (UInt16(buffer[2]) << 8))
        let distance = Int(UInt32(buffer[5]) | (UInt32(buffer[6]) << 8) | (UInt32(buffer[7]) << 16) | (UInt32(buffer[8]) << 24))
        let calories = Int(UInt32(buffer[9]) | (UInt32(buffer[10]) << 8) | (UInt32(buffer[11]) << 16) | (UInt32(buffer[12]) << 24))
        
        return (steps, distance, calories)
    }
    
    /// 심박수 측정 명령 전송
    func measureHeartRate() {
        guard
            let service = peripheral.services?.first(where: { $0.uuid == MiBandService.UUID_SERVICE_HEART_RATE }),
            let characteristic = service.characteristics?.first(where: { $0.uuid == MiBandService.UUID_CHARACTERISTIC_HEART_RATE_CONTROL })
        else {
            print("Heart Rate Service or Characteristic not found")
            return
        }
        
        let data = Data(MiBandService.COMMAND_START_HEART_RATE_MEASUREMENT)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    /// 심박수 데이터에서 BPM 추출
    func getHeartRate(heartRateData: Data) -> Int {
        print("--- Updating Heart Rate ---")
        
        let buffer = [UInt8](heartRateData)
        
        guard buffer.count >= 2 else { return 0 }
        
        let bpm: UInt16
        if buffer[0] & 0x01 == 0 {
            bpm = UInt16(buffer[1])
        } else {
            bpm = (UInt16(buffer[1]) << 8) | UInt16(buffer[2])
        }
        
        return Int(bpm)
    }
    
    // MARK: - Private Methods
    
    /// 진동 명령 전송
    private func sendVibrationCommand(_ alert: [Int8]) {
        guard
            let service = peripheral.services?.first(where: { $0.uuid == MiBandService.UUID_SERVICE_ALERT }),
            let characteristic = service.characteristics?.first(where: { $0.uuid == MiBandService.UUID_CHARACTERISTIC_VIBRATION_CONTROL })
        else {
            print("Vibration Service or Characteristic not found")
            return
        }
        
        let data = Data(alert.map { UInt8(bitPattern: $0) })
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
}
