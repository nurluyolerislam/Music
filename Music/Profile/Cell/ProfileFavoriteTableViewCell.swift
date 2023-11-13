//
//  ProfileFavoreCell.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import UIKit

final class ProfileFavoriteTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    static let reuseID = "ProfileFavoreCell"
    
    //MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.anchor(size: .init(width: 50, height: 50))
        imageView.image = UIImage(named: "profileImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Colifornia living vibes"
        return label
    }()
    
    lazy var recommendationReason: UILabel = {
        let label = UILabel()
        label.text = "Trending tracks by Tom"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var vstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            songNameLabel,
            recommendationReason
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .label
        button.anchor(size: .init(width: 30, height: 30))
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            songImageView,
            vstackView,
            playButton
        ])
        stackView.setCustomSpacing(15, after: songImageView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Configuration
    private func configureUI() {
        selectionStyle = .none
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, leading: 20, bottom: 10,trailing: 20))
    }
}
