//
//  BluetoothSerial.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/11/03.
//

import UIKit
import CoreBluetooth

protocol BluetoothSerialDelegate: AnyObject {
    
    /// 블루투스 상태가 변경되었을 때 호출됨
    func bluetoothSerial(_ serial: BluetoothSerial, didChangeStateTo state: CBManagerState)
    
    /// 주변기기를 발견했을 때 호출됨
    func bluetoothSerial(_ serial: BluetoothSerial, didDiscover peripheral: CBPeripheral, rssi: NSNumber)
    
    /// 기기 연결에 성공했을 때 호출됨
    func bluetoothSerial(_ serial: BluetoothSerial, didConnect peripheral: CBPeripheral)
    
    /// 기기 연결이 해제되었을 때 호출됨
    func bluetoothSerial(_ serial: BluetoothSerial, didDisconnect peripheral: CBPeripheral, error: Error?)
    
    /// 데이터를 수신했을 때 호출됨
    func bluetoothSerial(_ serial: BluetoothSerial, didReceive data: Data)
}

/// 블루투스 통신을 담당하는 클래스. Central 역할을 수행하며, 주변 BLE 기기를 검색하고 연결하고 데이터 송수신을 처리함.
class BluetoothSerial: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /// centralManager는 블루투스 주변기기를 검색하고 연결하는 역할을 수행
    var centralManager: CBCentralManager!
    
    /// 연결 시도 중인 주변기기
    var pendingPeripheral: CBPeripheral?
    
    /// 연결된 주변기기. 데이터 송수신에 사용
    var connectedPeripheral: CBPeripheral?
    
    /// 데이터를 쓰기 위한 characteristic
    weak var writeCharacteristic: CBCharacteristic?
    
    /// 데이터 쓰기 타입 (응답 여부 설정)
    private var writeType: CBCharacteristicWriteType = .withResponse
    
    /// 검색할 서비스 UUID
    var serviceUUID = CBUUID(string: "FFE0")
    
    /// 데이터 송수신에 사용할 characteristic UUID
    var characteristicUUID = CBUUID(string: "FFE1")
    
    /// 이벤트를 전달할 델리게이트
    weak var delegate: BluetoothSerialDelegate?
    
    // MARK: - 초기화
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - 스캔 관련 메서드
    
    /// 블루투스 상태가 변경될 때 호출됨
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("블루투스가 켜졌습니다.")
        case .poweredOff:
            print("블루투스가 꺼졌습니다.")
        case .unauthorized, .unsupported, .resetting, .unknown:
            print("블루투스를 사용할 수 없는 상태입니다: \(central.state.rawValue)")
        @unknown default:
            print("알 수 없는 블루투스 상태입니다.")
        }
        
        let isOn = (central.state == .poweredOn)
        delegate?.bluetoothSerial(self, didChangeStateTo: central.state)
        
        // 상태가 바뀔 때 기존 연결 상태 초기화
        pendingPeripheral = nil
        connectedPeripheral = nil
    }
    
    /// 주변 BLE 기기 검색 시작
    func startScan() {
        guard centralManager.state == .poweredOn else {
            print("블루투스가 꺼져 있어 검색할 수 없습니다.")
            return
        }
        
        print("BLE 기기 검색 시작")
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        
        // 이미 연결된 기기 검색
        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID])
        for peripheral in peripherals {
            print("이미 연결된 기기 발견: \(peripheral.name ?? "이름 없음")")
            // TODO: 필요한 경우 자동 연결 시도 가능
        }
    }
    
    /// BLE 검색 중단
    func stopScan() {
        centralManager.stopScan()
        print("BLE 검색 중단")
    }
    
    // MARK: - 연결 관련 메서드
    
    /// 특정 기기 연결 시도
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        print("기기 연결 시도: \(peripheral.name ?? "이름 없음")")
        pendingPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    /// 기기 연결 성공 시 호출됨
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("기기 연결 성공: \(peripheral.name ?? "이름 없음")")
        peripheral.delegate = self
        pendingPeripheral = nil
        connectedPeripheral = peripheral
        
        delegate?.bluetoothSerial(self, didConnect: peripheral)
        
        // 서비스 검색 시작
        peripheral.discoverServices([serviceUUID])
    }
    
    /// 기기 연결 실패 시 호출됨
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("기기 연결 실패: \(peripheral.name ?? "이름 없음"), 오류: \(error?.localizedDescription ?? "없음")")
        pendingPeripheral = nil
    }
    
    /// 연결이 끊겼을 때 호출됨
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("기기 연결 해제됨: \(peripheral.name ?? "이름 없음"), 오류: \(error?.localizedDescription ?? "없음")")
        if connectedPeripheral == peripheral {
            connectedPeripheral = nil
        }
        delegate?.bluetoothSerial(self, didDisconnect: peripheral, error: error)
    }
    
    // MARK: - 주변기기 검색 시 호출
    
    /// BLE 기기 발견 시 호출됨
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("기기 발견: \(peripheral.name ?? "이름 없음"), RSSI: \(RSSI)")
        delegate?.bluetoothSerial(self, didDiscover: peripheral, rssi: RSSI)
        // TODO: 발견된 기기 리스트를 저장하거나 UI에 표시할 수 있음
    }
    
    // MARK: - Peripheral Delegate
    
    /// 서비스 검색 완료 시 호출됨
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("서비스 검색 오류: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("서비스 발견: \(service.uuid)")
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    /// characteristic 검색 완료 시 호출됨
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("특성 검색 오류: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("특성 발견: \(characteristic.uuid)")
            
            if characteristic.uuid == characteristicUUID {
                writeCharacteristic = characteristic
                writeType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
                
                // TODO: 필요한 경우 notify 활성화 (구독)
                // peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    /// characteristic 값이 업데이트 될 때 호출됨 (알림 구독 시)
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("값 업데이트 오류: \(error!.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else { return }
        
        print("데이터 수신: \(data as NSData)")
        
        delegate?.bluetoothSerial(self, didReceive: data)
        
        // TODO: 받은 데이터를 분석하거나 처리하는 로직 추가
    }
    
    // MARK: - 데이터 전송
    
    /// 데이터를 주변기기에 전송
    func sendData(_ data: Data) {
        guard let peripheral = connectedPeripheral,
              let characteristic = writeCharacteristic else {
            print("데이터 전송 실패: 연결된 기기나 characteristic이 없음")
            return
        }
        
        peripheral.writeValue(data, for: characteristic, type: writeType)
        print("데이터 전송: \(data as NSData)")
    }
}
