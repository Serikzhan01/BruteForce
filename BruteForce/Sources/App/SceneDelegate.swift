//
//  SceneDelegate.swift
//  BruteForce
//
//  Created by Serikzhan on 09.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           guard let windowScene = (scene as? UIWindowScene) else { return }
           window = UIWindow(windowScene: windowScene)
           let viewController = ViewController()
           window?.rootViewController = viewController
           window?.makeKeyAndVisible()
       }
}
