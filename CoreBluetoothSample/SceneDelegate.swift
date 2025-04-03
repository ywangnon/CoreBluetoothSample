//
//  SceneDelegate.swift
//  CoreBluetoothSample
//
//  Created by Hansub Yoo on 2022/11/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Scene Lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowScene에 UIWindow `window`를 연결하는 설정을 옵션으로 할 수 있습니다.
        // 스토리보드를 사용하는 경우, `window` 프로퍼티는 자동으로 초기화되고 연결됩니다.
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // 시스템에 의해 씬이 해제될 때 호출됩니다.
        // 씬이 백그라운드로 들어가거나 세션이 폐기될 때 발생합니다.
        // 이 씬에 관련된 리소스를 해제할 수 있습니다.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 씬이 비활성 상태에서 활성 상태로 변경될 때 호출됩니다.
        // 비활성 상태에서 일시 중지된 작업을 다시 시작할 수 있습니다.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // 씬이 활성 상태에서 비활성 상태로 이동할 때 호출됩니다.
        // 예를 들어, 전화가 오는 등의 일시적인 방해가 있을 때 발생합니다.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 씬이 백그라운드에서 포그라운드로 전환될 때 호출됩니다.
        // 백그라운드로 들어갈 때의 변경사항을 되돌릴 수 있습니다.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 씬이 포그라운드에서 백그라운드로 전환될 때 호출됩니다.
        // 데이터를 저장하고, 공유 리소스를 해제하고, 씬의 상태 정보를 저장하여 복원할 수 있도록 합니다.
    }
}
