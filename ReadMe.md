# MiBand BLE Sample Project

본 프로젝트는 CoreBluetooth를 사용하여 **Xiaomi Mi Band**와 통신하고, **걸음수(Steps)**, **배터리 상태(Battery)**, **심박수(Heart Rate)** 데이터를 읽어오는 iOS 앱 샘플입니다.
주요 목표는 Mi Band로 BLE 프로토콜을 이해하고, 건강 데이터를 효과적으로 추출하는 데 있습니다.

---

## 🛠 프로젝트 구조

| 파일명 | 설명 |
|:---|:---|
| `MibandViewController.swift` | BLE 통신 전체 흐름을 담당하는 메인 ViewController |
| `MiBand.swift` | Mi Band 디바이스 제어 및 데이터 추출 기능을 담당하는 헬퍼 클래스 |
| `MiBandService.swift` | Mi Band의 BLE 서비스 및 캐릭터리스틱 UUID 정의 및 명령어 집합 |

---

## 🔄 동작 흐름

1. 앱 시작 시 `CBCentralManager` 초기화
2. Bluetooth 상태 체크 (`poweredOn`일 때만 진행)
3. 연결된 Mi Band 검색
    - 이미 연결된 경우: 바로 연결
    - 없으면: 주변 Mi Band 스캔 후 연결
4. 주변기기 연결 완료 후:
    - BLE 서비스 및 캐릭터리스틱 검색
    - 필요한 데이터 읽기 또는 구독
5. 데이터 수신 시:
    - 걸음수, 배터리, 심박수 정보를 디코딩 및 출력

---

## ✨ 주요 기능

- **걸음수(Steps) 읽기**
  - 실시간 걸음수, 거리(m), 칼로리(kcal) 가져오기
  
- **배터리 상태(Battery) 읽기**
  - 배터리 퍼센티지(%) 가져오기 및 상태 분류
  
- **심박수(Heart Rate) 측정 및 읽기**
  - 심박수 측정 명령 전송 후 BPM 데이터 수신

- **진동 제어(Vibration Control)**
  - Mi Band 진동 시작 및 중단

---

## 📡 사용된 주요 BLE UUID

| 이름 | UUID |
|:---|:---|
| Mi Band 서비스 | `FEE0` |
| 심박수 서비스 (Heart Rate Service) | `180D` |
| 알림 서비스 (Alert Service) | `1802` |
| 걸음수 캐릭터리스틱 (Realtime Steps) | `00000007-0000-3512-2118-0009af100700` |
| 배터리 캐릭터리스틱 (Battery Info) | `00000006-0000-3512-2118-0009af100700` |
| 심박수 데이터 캐릭터리스틱 | `2A37` |
| 진동 제어 캐릭터리스틱 | `2A06` |

---

## 🧹 코드 스타일 특징

- 최신 Swift 5+ 스타일 적용
- `extension`을 통한 delegate 분리 (`CBCentralManagerDelegate`, `CBPeripheralDelegate`)
- Force Unwrap 제거, `guard` 사용으로 안전성 강화
- `Data` 기반으로 BLE 패킷 처리
- 주석 및 코드 흐름 가독성 향상

---

## 📦 향후 확장 가능성 (Ideas)

- 건강 데이터를 UI 화면에 직접 표시 (걸음수, 배터리, 심박수)
- 심박수 측정 시 애니메이션 추가
- 주기적인 심박수 자동 측정 기능
- 알림(Notification) 수신 후 진동 기능 연동
- Combine 기반 비동기 통신으로 업그레이드
