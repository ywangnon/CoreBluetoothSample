//
//  BluetoothSettingViewController.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/11/01.
//

import UIKit
import CoreBluetooth

class BluetoothSettingViewController: UIViewController {
    
    
    
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
    
    
}

extension BluetoothSettingViewController: CBPeripheralDelegate {
    
}
