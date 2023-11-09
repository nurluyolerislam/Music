//
//  MainTabBarVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lazy var homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         tag: 0)
        
        lazy var searchVC = UINavigationController(rootViewController: SearchVC())
        searchVC.tabBarItem = UITabBarItem(title: "Search",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           tag: 0)
        
        lazy var profileVC = UINavigationController(rootViewController: ProfileVC())
        profileVC.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person"),
                                            tag: 0)
        
        tabBar.tintColor = .label
        
        viewControllers = [
            homeVC,
            searchVC,
            profileVC
        ]
    }
    
}
