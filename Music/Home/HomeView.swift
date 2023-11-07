//
//  HomeView.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

class HomeView: UIView {
    
    //MARK: - UI Elements
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Good Afternoon, Yaşar Babba"
        return label
    }()
    
    lazy var profileButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Functions
    private func configureUI() {
        configureProfileButton()
        configureWelcomeLabel()
    }
    
    private func configureProfileButton() {
        addSubview(profileButton)
        profileButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                             trailing: safeAreaLayoutGuide.trailingAnchor,
                             padding: .init(trailing: 10),
                             size: .init(width: 50, height: 50))
    }
    
    private func configureWelcomeLabel() {
        addSubview(welcomeLabel)
        welcomeLabel.anchor(top: profileButton.topAnchor,
                            leading: safeAreaLayoutGuide.leadingAnchor,
                            bottom: profileButton.bottomAnchor,
                            padding: .init(leading: 10))
    }
    
}

#Preview {
    HomeView()
}


extension UIView {

    static func spacer(size: CGFloat = 10, for layout: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let spacer = UIView()
        
        if layout == .horizontal {
            spacer.widthAnchor.constraint(equalToConstant: size).isActive = true
        } else {
            spacer.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        
        return spacer
    }

}
