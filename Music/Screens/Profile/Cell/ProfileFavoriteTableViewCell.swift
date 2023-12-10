//
//  ProfileFavoriteTableViewCell.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import UIKit

final class ProfileFavoriteTableViewCell: UITableViewCell {
    
    //MARK: - Reuse Identifier
    static let reuseID = "ProfileFavoriteTableViewCell"
    
    
    //MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.anchor(size: .init(width: 50, height: 50))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var artistAndSongNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            artistAndSongNameLabel,
            albumNameLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .label
        button.anchor(size: .init(width: 30, height: 30))
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            songImageView,
            vStackView,
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
        stackView.fillSuperview(padding: .init(top: 10, bottom: 10))
    }
    
    func updateUI(track: Track?) {
        guard let track else { return }
        if let album = track.album {
            if let albumImageURL = album.coverXl {
                songImageView.kf.setImage(with: URL(string: albumImageURL))
            }
            
            if let albumName = track.title {
                albumNameLabel.text = albumName
            }
        }
        
        if let artist = track.artist,
           let songName = track.title {
            if let artistName = artist.name {
                artistAndSongNameLabel.text = "\(artistName) - \(songName)"
            }
        }
    }
}
