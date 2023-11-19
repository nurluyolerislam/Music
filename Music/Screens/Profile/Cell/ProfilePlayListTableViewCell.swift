//
//  ProfilePlayListTableViewCell.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import UIKit

final class ProfilePlayListTableViewCell: UITableViewCell {
    
    //MARK: - Reuse Identifier
    static let reuseID = "ProfileAlbumTableViewCell"
    
    
    //MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var textVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            playlistNameLabel,
            trackCountLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var containerHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            playlistImageView,
            textVStackView
        ])
        stackView.setCustomSpacing(15, after: playlistImageView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.anchor(size: .init(width: 50, height: 50))
        imageView.image = UIImage(systemName: "music.note.list")
        imageView.tintColor = .systemPink
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var playlistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private lazy var trackCountLabel: UILabel = {
        let label = UILabel()
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
        containerHStackView.fillSuperview(padding: .init(top: 10,
                                                         trailing: 20))
    }
    
    
    //MARK: - Helper Functions
    func updateUI(userPlaylist: UserPlaylist) {
        if let title = userPlaylist.title {
            playlistNameLabel.text = title
        }
        
        if let trackCount = userPlaylist.trackCount {
            trackCountLabel.text = "\(trackCount) Tracks"
        }
    }
}
