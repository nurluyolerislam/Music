//
//  PopularSongsTableViewCell.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

class PopularSongsTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    static let reuseID = "PopularSongsTableViewCell"
    
    //MARK: - UI Elements
    lazy var containerView: UIView = {
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
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending tracks by Tom"
        return label
    }()
    
    lazy var vstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            songNameLabel,
            albumNameLabel
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
    
    lazy var stackView: UIStackView = {
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
    
    private func configureUI() {
        selectionStyle = .none
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, bottom: 10))
    }
}

struct PopularSongsTableViewCellModel {
    let image: UIImage
    let songName: String
    let albumName: String
}
