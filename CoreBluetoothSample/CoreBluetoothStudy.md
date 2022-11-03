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

- 주변기기를 검색, 연결, 관리하기 위한 클래스
- Central에서 수행하는 discover(검색), connect(연결)을 담당하는 클래스

### CBPeripheral

- 주변기기를 나타내는 클래스
- 검색되거나 연결된 주변장치를 저장하고 관리하며 데이터 통신을 수행

### CBCCentralManagerDelegate

- 주변기기를 탐색하고 관리하기 위해 발생되는 Update를 지원하는 프로토콜

### CBPeripheralDelegate

- 주변기기의 서비스들을 사용하기 위해 발생되는 Update를 지원하는 프로토콜

### CBService

- 장치의 특성 또는 기능을 수행하는 관련 동작과 데이터 집합

### CBCharacteristic

- 주변 장치의 서비스의 추가 정보

## Peripheral의 구조와 서비스

- peripheral의 데이터는 1개 이상의 service로 구성
- service는 1개 이상의 characteristic으로 구성
- service로 특정 데이터를 측정하거나 특정 기기 제어
- service는 peripheral이 가지고 있는 기능으로 볼 수 있음
- characteristic은 peripheral이 가지고 있는 실질적인 데이터

## 시리얼이란?

1비트씩 순차적으로 데이터를 송수신하는 프로토콜

