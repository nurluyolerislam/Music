//
//  AlertContainerView.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import UIKit

class AlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
  
       backgroundColor     = .systemBackground
       layer.cornerRadius  = 16
       layer.borderWidth   = 2
       layer.borderColor   = UIColor.white.cgColor
       translatesAutoresizingMaskIntoConstraints = false
    }
    
}
