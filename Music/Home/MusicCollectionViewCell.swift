//
//  MusicCollectionViewCell.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "MusicCollectionViewCell"
    
    //MARK: - UI Elements
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let layer = UIView()
        layer.backgroundColor = .systemBackground
        layer.layer.opacity = 0.5
        imageView.addSubview(layer)
        layer.fillSuperview()
        
        return imageView
    }()
    
    lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstLabel,
            secondLabel
        ])
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
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
        configureStackView()
    }
    
    private func configureImageView () {
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    private func configureStackView () {
        imageView.addSubview(stackView)
        stackView.centerInSuperview()
    }
}

struct MusicCollectionViewCellModel {
    let image: UIImage
    let firstLabelText: String
    let secondLabelText: String
}
