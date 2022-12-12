//
//  BluetoothSettingViewController.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/11/01.
//

import UIKit
import CoreBluetooth

class BluetoothSettingViewController: UIViewController {
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var connectedPeripheral: CBPeripheral?
    var miband: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}

extension BluetoothSettingViewController: CBCentralManagerDelegate {
    /// 블루투스가 켜진 상태인지 확인. 시스템의 Bluetooth 상태가 변경될 때마다 호출. 앱이 처음 시작될 때 실행
    /// - Parameter central: 중앙장치
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("관리자의 상태와 블루투스 서비스 연결을 알 수 없음")
        case .resetting:
            print("연결이 중단됨")
        case .unsupported:
            print("장치가 블루투스 지원 안 함")
        case .unauthorized:
            // 사용자가 블루투스 사용에 대한 앱 권한 거부. 앱 설정에서 다시 활성화 해야 함
            print("사용 권한 거부")
        case .poweredOff:
            // 사용자가 블루투스를 끔. 설정 및 제어 센터에서 다시 켜야 함
            print("파워 오프")
        case .poweredOn:
            // 블루투스가 활성화되고 승인되었으며 앱 사용 준비가 됨
            print("파워 온")
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        @unknown default:
            print("모름")
        }
    }
    
    
    /// 장치를 찾았을 때 호출
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("찾는 중")
        print("주변 장치", peripheral)
        print("이름", peripheral.name ?? "unnamed device")
        
        if peripheral.name == "Mi Smart Band 5" {
            self.miband = peripheral
            self.miband.delegate = self
            centralManager.stopScan()
            centralManager.connect(self.miband, options: nil)
            print("서비스", self.miband.identifier.uuidString)
        }
    }
    
    /// 연결되면 호출
    ///
    /// 기기의 정보를 받아오거나 수정
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("찾음")
        print("기기 정보", peripheral)
        peripheral.discoverServices(nil)
    }
    
    
}

extension BluetoothSettingViewController: CBPeripheralDelegate {
    /// 주변 장치에서 서비스 정보를 받게 되면 호출
    /// service 검색에 성공시 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("정보 받음")
        print("peripheral", peripheral)
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            print("service Name: \(service.uuid), uuidString: \(service.uuid.uuidString)")
            // 검색된 모든 service에 대해서 characteristic을 검색.
            // 파라미터로 nil을 설정하면 해당 service의 모든 characiteristic 검색
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /**
     <CBService: 0x2833d8800, isPrimary = YES, UUID = Device Information>
     <CBService: 0x2833d8380, isPrimary = YES, UUID = 00001530-0000-3512-2118-0009AF100700>
     <CBService: 0x2833d8880, isPrimary = YES, UUID = 1811>
     <CBService: 0x2833d8440, isPrimary = YES, UUID = 1802>
     <CBService: 0x2833d8640, isPrimary = YES, UUID = Heart Rate>
     <CBService: 0x2833d8980, isPrimary = YES, UUID = FEE0>
     <CBService: 0x2833d86c0, isPrimary = YES, UUID = FEE1>
     <CBService: 0x2833d8740, isPrimary = YES, UUID = Battery>
     <CBService: 0x2833d8840, isPrimary = YES, UUID = 3802>
     */
    
    // characteristic 검색에 성공 시 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//
//        for characteristic in characteristics {
//            print("characteristic: \(characteristic)")
//
//            if characteristic.properties.contains(.read) {
//                print("readable")
//                peripheral.readValue(for: characteristic)
//            }
//        }
        
        print(error ?? service.characteristics)
        
        service.characteristics?.forEach({ characteristic in
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        })
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("didUpdateValueFor characteristic")
//        print(characteristic.value ?? "can't get value")
        
        let valueBytes: [UInt8] = characteristic.value?.map({ v in
            return v
        })
    }
}

extension UInt32 {
    static func from(bytes: [UInt8]) -> UInt32? {
        guard bytes.count <= 4 else { return nil }
        return bytes
            .enumerated()
            .map { UInt32($0.element) << UInt32($0.offset * 8) }
            .reduce(0, +)
    }
}
