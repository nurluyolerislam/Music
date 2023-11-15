//
//  SearchTableViewCell.swift
//  Music
//
//  Created by Yaşar Duman on 11.11.2023.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    static let reuseID = "SearchTableViewCell"
    
    var track: Track?
    
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
    
    
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            songImageView,
            vstackView
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
        accessoryType = .disclosureIndicator
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, bottom: 10, trailing: 40))
    }
    
    func updateUI(track: Track) {
        if let album = track.album {
            if let albumImageURL = album.coverXl {
                songImageView.kf.setImage(with: URL(string: albumImageURL))
            }
            
            if let albumName = track.title {
                albumNameLabel.text = albumName
            }
        }
        
        if let artist = track.artist {
            if let artistName = artist.name,
               let songName = track.title{
                songNameLabel.text = "\(artistName) - \(songName)"
            }
        }
    }
}

struct SearchTableViewCellModel {
    let image: UIImage
    let songName: String
    let albumName: String
}
