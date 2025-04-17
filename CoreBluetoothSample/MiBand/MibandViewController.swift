//
//  MibandViewController.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/12/12.
//

import UIKit
import CoreBluetooth

/// Mi Band와 연결하여 헬스 데이터를 관리하는 ViewController
class MibandViewController: UIViewController {
    
    // MARK: - Properties
    private var centralManager: CBCentralManager!
    private var miBand: MiBand?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bluetooth Central Manager 초기화 및 Delegate 설정
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

// MARK: - CBCentralManagerDelegate
extension MibandViewController: CBCentralManagerDelegate {
    
    /// Bluetooth 상태 업데이트 콜백
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered ON.")
            connectToLastKnownDevice()
            
        default:
            print("Bluetooth State: \(central.state.rawValue)")
        }
    }
    
    /// 이미 연결된 기기가 있으면 연결하고, 없으면 스캔 시작
    private func connectToLastKnownDevice() {
        let connectedPeripherals = centralManager.retrieveConnectedPeripherals(withServices: [MiBandService.UUID_SERVICE_MIBAND_SERVICE])
        
        if let device = connectedPeripherals.first {
            miBand = MiBand(device)
            centralManager.connect(device, options: nil)
        } else {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    /// 주변기기 발견 시 호출
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name?.contains("MI Band 2") == true {
            print("Discovered Mi Band 2. Connecting...")
            miBand = MiBand(peripheral)
            centralManager.connect(peripheral, options: nil)
        } else {
            print("Discovered unknown device: \(peripheral.name ?? "Unnamed Device")")
        }
    }
    
    /// 주변기기 연결 완료 시 호출
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: \(peripheral.name ?? "Unknown Device")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

// MARK: - CBPeripheralDelegate
extension MibandViewController: CBPeripheralDelegate {
    
    /// 서비스 검색 완료 콜백
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /// 캐릭터리스틱 검색 완료 콜백
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            switch characteristic.uuid {
            case MiBandService.UUID_CHARACTERISTIC_BATTERY_INFO:
                peripheral.readValue(for: characteristic)
                
            case MiBandService.UUID_CHARACTERISTIC_HEART_RATE_DATA:
                peripheral.setNotifyValue(true, for: characteristic)
                
            case MiBandService.UUID_CHARACTERISTIC_REALTIME_STEPS:
                updateSteps()
                
            case MiBandService.UUID_CHARACTERISTIC_CONFIGURATION:
                setDeviceConfiguration(for: characteristic, on: peripheral)
                
            default:
                print("Unhandled Characteristic: \(characteristic.uuid)")
            }
        }
    }
    
    /// 캐릭터리스틱 값 업데이트 콜백
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }
        
        switch characteristic.uuid {
        case CBUUID(string: "FF06"): // 걸음수 characteristic
            let steps = value.withUnsafeBytes { $0.load(as: Int.self) }
            print("Steps: \(steps)")
            
        case MiBandService.UUID_CHARACTERISTIC_BATTERY_INFO:
            updateBattery(miBand?.getBattery(batteryData: value) ?? 0)
            
        case MiBandService.UUID_CHARACTERISTIC_HEART_RATE_DATA:
            updateHeartRate(miBand?.getHeartRate(heartRateData: value) ?? 0)
            
        default:
            print("Updated Characteristic: \(characteristic.uuid)")
        }
    }
}

// MARK: - Private Methods
private extension MibandViewController {
    
    /// 걸음수 정보 업데이트
    func updateSteps() {
        guard let (steps, distance, calories) = miBand?.getSteps() else {
            print("Failed to fetch steps data.")
            return
        }
        
        print("Steps: \(steps)")
        print("Distance: \(distance) meters")
        print("Calories: \(calories) kcal")
    }
    
    /// 심박수 정보 업데이트
    func updateHeartRate(_ heartRate: Int) {
        miBand?.startVibrate()
        print("Heart Rate: \(heartRate) bpm")
    }
    
    /// 배터리 상태 업데이트
    func updateBattery(_ batteryLevel: Int) {
        let status: String
        switch batteryLevel {
        case 76...100:
            status = "Battery is powerful"
        case 51...75:
            status = "Battery is mid-level"
        case 26...50:
            status = "Battery is low"
        default:
            status = "Battery is very low"
        }
        
        print("\(status) (\(batteryLevel)%)")
    }
    
    /// 디바이스 설정 (시간 포맷 등)
    func setDeviceConfiguration(for characteristic: CBCharacteristic, on peripheral: CBPeripheral) {
        var configData: [UInt8] = [0x0A, 0x20, 0x00, 0x00]
        let data = Data(configData)
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
}
