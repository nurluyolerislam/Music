//
//  PlayerVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

class PlayerVC: UIViewController {

    lazy var playerUIView = PlayerUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = playerUIView
    }

}
