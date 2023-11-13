//
//  ProfilePlayListTableViewCell.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import UIKit

final class ProfilePlayListTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    static let reuseID = "ProfileAlbumTableViewCell"
    
    //MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var textVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            playListName,
            numberOfSound
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var containerHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            songImageView,
            textVStackView
        ])
        stackView.setCustomSpacing(15, after: songImageView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
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
    
    lazy var playListName: UILabel = {
        let label = UILabel()
        label.text = "Colifornia living vibes"
        label.textColor = .label
        return label
    }()
    
    lazy var numberOfSound: UILabel = {
        let label = UILabel()
        label.text = "101 Tracks"
        label.textColor = .secondaryLabel
        return label
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
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addSubview(containerHStackView)
        containerHStackView.fillSuperview(padding: .init(top: 10,leading: 20, bottom: 10, trailing: 20))
    }
}
