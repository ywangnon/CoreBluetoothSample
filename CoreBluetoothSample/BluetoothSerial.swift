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
//    var serviceUUID = CBUUID(string: "FFE0")
    
    //characteristicUUID 포함해서 UUID를 모르기 때문에 넘어감
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        pendingPeripheral = nil
        connectedPeripheral = nil
    }
    
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        
        
    }
}
