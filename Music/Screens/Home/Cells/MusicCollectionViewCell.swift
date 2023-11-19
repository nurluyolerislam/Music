//
//  MusicCollectionViewCell.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

final class MusicCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Reuse Identifier
    static let reuseID = "MusicCollectionViewCell"
    
    
    //MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let layer = UIView()
        layer.backgroundColor = .systemBackground
        layer.layer.opacity = 0.5
        imageView.addSubview(layer)
        layer.fillSuperview()
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.height / 8
    }
    
    
    //MARK: - Configuration Methods
    private func configureUI () {
        configureImageView()
        configureLabel()
    }
    
    private func configureImageView () {
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    private func configureLabel() {
        imageView.addSubview(label)
        label.centerInSuperview(size: .init(width: imageView.frame.width, height: imageView.frame.height))
    }
    
    
    //MARK: - Helper Functions
    func updateUI(playlist: Playlist) {
        if let imageURL = playlist.pictureXl {
            imageView.kf.setImage(with: URL(string: imageURL))
        }
        
        if let title = playlist.title {
            label.text = title
        }
    }
    
    func updateUI(genresPlaylist: GenresPlayList) {
        if let imageURL = genresPlaylist.pictureXl {
            imageView.kf.setImage(with: URL(string: imageURL))
        }
        
        if let name = genresPlaylist.name {
            label.text = name
        }
    }
    
    func updateUI(artist: Artist) {
        if let imageURL = artist.pictureXl {
            imageView.kf.setImage(with: URL(string: imageURL))
        }
        
        if let name = artist.name {
            label.text = name
        }
    }
    
}
