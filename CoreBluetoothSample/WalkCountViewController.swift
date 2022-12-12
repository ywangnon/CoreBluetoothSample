//
//  WalkCountViewController.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/12/11.
//

import UIKit
import CoreBluetooth

class WalkCountViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    var manager : CBCentralManager!
    var miBand : CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Name: \(peripheral.name)")
        
        if (peripheral.name == "Mi Smart Band 5") {
            
            self.miBand = peripheral
            self.miBand.delegate = self
            manager.stopScan()
            manager.connect(self.miBand, options: nil)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let servicePeripherals = peripheral.services as [CBService]?
        {
            for service in servicePeripherals
            {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characterArray = service.characteristics as [CBCharacteristic]?
        {
            for cc in characterArray
            {
                if (cc.uuid.uuidString == "FF06") {
                    print("찾는 중")
                    peripheral.readValue(for: cc)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic.uuid.uuidString == "FF06") {
//            let value = UnsafePointer(bitPattern: characteristic)
//            print("걸음 수: \(value)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var msg = ""
        switch (central.state) {
        
        case .poweredOff:
            msg = "Bluetooth 꺼짐"
        case .poweredOn:
            msg = "Bluetooth 켜져있음"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            msg = "Bluetooth 사용할 수 없음"
        default:
            break
        }
        print("STAT: \(msg)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
