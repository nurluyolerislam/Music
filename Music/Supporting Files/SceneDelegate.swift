//
//  SceneDelegate.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // MARK: - onboardingVC
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        // Uygulama ilk kez açılıyorsa, onboarding ekranını göster
        
        if !hasLaunchedBefore {
            let onboardingVC = OnboardingVC()
            onboardingVC.modalPresentationStyle = .fullScreen
            window?.rootViewController = onboardingVC
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            let loginVC = LoginVC()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            window?.rootViewController = nav
        }
        
        // MARK: - kullanıcı sürekli giriş yapmamsı için yapılan işlem kullanıcıyı hatırlama işlemi
        if Auth.auth().currentUser != nil {
            let TabBar = MainTabBarVC()
            TabBar.modalPresentationStyle = .fullScreen
            window?.rootViewController = TabBar
        }
         self.window?.makeKeyAndVisible()
    }

}

