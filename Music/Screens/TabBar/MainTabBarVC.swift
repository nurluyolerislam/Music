//
//  MainTabBarVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

final class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lazy var homeVC = HomeVC()
        lazy var searchVC = SearchVC()
        lazy var profileVC = ProfileVC()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         tag: 0)
        
        searchVC.tabBarItem = UITabBarItem(title: "Search",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           tag: 0)
        
        profileVC.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person"),
                                            tag: 0)
        
        tabBar.tintColor = .label
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
    
}
