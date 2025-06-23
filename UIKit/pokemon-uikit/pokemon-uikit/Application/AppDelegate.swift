//
//  AppDelegate.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/21/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // 앱이 실행된 직후 호출
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    // iOS 13 이상에서 멀티 윈도우(씬 기반 구조)를 사용할 때 새로운 Scene이 생성될 때 호출
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // 씬(화면)을 닫았을 때 호출
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

