#  CoreBluetooth

- Apple에서 블루투스 기능을 제공하는 공용 프레임워크. 
- Central(중앙장치) ↔ Peripheral(주변장치) 연결

## 예제 목표

- 미밴드에 블루투스로 연결하여 데이터 읽어오기 & 보내기

## Info

블루투스 연결에 대한 경고를 하고 사용자에게서 권한을 허락받아야 함

**Key**: Privacy – Bluetooth Always Usage Description
**Value**: User-facing description of why your app uses Bluetooth.

## CoreBluetooth 객체들

### CBCentralManager

주변기기를 검색, 연결, 관리하기 위한 오브젝트

### CBPeripheral

주변기기를 나타내는 오브젝트. 이를 통해 데이터를 송수신

### CBCCentralManagerDelegate

주변기기를 탐색하고 관리하기 위해 발생되는 Update를 지원하는 프로토콜

### CBPeripheralDelegate

주변기기의 서비스들을 사용하기 위해 발생되는 Update를 지원하는 프로토콜




