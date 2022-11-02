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
            self.centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            print("모름")
        }
    }
    
    
    /// 장치를 찾았을 때 호출
    /// - Parameters:
    ///   - central: <#central description#>
    ///   - peripheral: <#peripheral description#>
    ///   - advertisementData: <#advertisementData description#>
    ///   - RSSI: <#RSSI description#>
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("찾는 중")
        print("주변 장치", peripheral)
        print("이름", peripheral.name ?? "unnamed device")
        print("기능", peripheral.services)
    }
    
    /// 연결되면 호출
    ///
    /// 기기의 정보를 받아오거나 수정
    /// - Parameters:
    ///   - central: <#central description#>
    ///   - peripheral: <#peripheral description#>
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("찾음")
        print("기기 정보", peripheral)
    }
    
    
}

extension BluetoothSettingViewController: CBPeripheralDelegate {
    /// 주변 장치에서 서비스 정보를 받게 되면 호출
    /// - Parameters:
    ///   - peripheral: <#peripheral description#>
    ///   - error: <#error description#>
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("정보 받음")
        print("peripheral", peripheral)
        print("services", error)
    }
}
