//
//  BluetoothSerial.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/11/03.
//

import UIKit
import CoreBluetooth

/// 블루투스 통신을 담당할 시리얼을 클래스로 선언. Corebluetooth를 사용하기 위해서 프로토콜을 추가
class BluetoothSerial: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /// centralManager은 블루투스 주변기기를 검색하고 연결하는 역할을 수행
    var centralManager : CBCentralManager!
    
    /// pendingPeripheral은 현재 연결을 시도하고 있는 블루투스 주변기기
    var pendingPeripheral : CBPeripheral!
    
    /// 연결에 성공한 주변기기. 기기와 통신을 시작하게 되면 이 객체를 이용
    var connectedPeripheral : CBPeripheral?
    
    /// 데이터를 주변기기에 보내기 위한 characteristic을 저장하는 변수
    weak var writeCharacteristic : CBCharacteristic?
    
    /// 데이터를 주변기기에 보내는 type을 설정. withResponse는 데이터를 보내면 이에 대한 답장이 오는 경우. withoutResponse는 데이터를 보내도 답장이 오지 않는 경우
    private var writeType : CBCharacteristicWriteType = .withResponse
    
    /// serviceUUID는 Peripheral이 가지고 있는 서비스의 UUID를 뜻함.
    var serviceUUID = CBUUID(string: "FFE0")
    
    //characteristicUUID 포함해서 UUID를 모르기 때문에 넘어감
    var characteristicUUID = CBUUID(string: "FFE1")
    
    /// CBCentralManagerDelegate에 포함되어 있는 메서드
    /// central 기기의 블루투스가 켜져있는지, 꺼져있는지 확인. 확인하여 centralManager.state의 값을 .powerOn 또는 .powerOff로 변경
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        pendingPeripheral = nil
        connectedPeripheral = nil
    }
    
    /// 기기 검색을 시작. 연결이 가능한 모든 주변기기를 serviceUUID를 통해 찾아냄
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        
        // CBCentralManager의 메서드인 scanForPeripherals를 호출하여 연결가능한 기기들을 검색.
        // 이 때 withService 파라미터에 nil을 입력하면 모든 종류의 기기가 검색됨
        // serviceUUID를 입력하면 특정 serviceUUID를 가진 기기만을 검색
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        
        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID])
        for peripheral in peripherals {
            
        }
    }
    
    /// 기기 검색 중단
    func stopScan() {
        centralManager.stopScan()
    }
    
    /// 파라미터로 넘어온 주변 기기를 CentralManager에 연결하도록 시도
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        // 연결 실패를 대비하여 현재 연결 중인 주변 기기를 저장
        pendingPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    // 기기가 검색될 때마다 호출되는 메서드
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
    }
    
    // 기기가 연결디면 호출되는 메서드
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        pendingPeripheral = nil
        connectedPeripheral = peripheral
        
        // peripheral의 Service들을 검색. 파라미터를 nil로 설정하면 peripheral의 모든 service를 검색
        peripheral.discoverServices([serviceUUID])
    }
    
}
