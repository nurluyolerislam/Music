//
//  HomeVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: - Variables
    lazy var homeView = HomeView()
    
    //MARK: - Lifecycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    //MARK: - Targets
    private func addTargets() {
        let profileImageGestureRecognizer = UITapGestureRecognizer(target: self,
                                               action: #selector(profileImageTapped))
        homeView.profileImage.addGestureRecognizer(profileImageGestureRecognizer)
    }
    
    
    //MARK: - @Actions
    @objc func profileImageTapped() {
        print("DEBUG: profileImage tapped")
    }
    
    
}
