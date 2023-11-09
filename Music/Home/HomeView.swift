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
        label.text = "Good Afternoon, Erislam Nurluyol"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.anchor(size: .init(width: 50, height: 50))
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            welcomeLabel,
            profileImage
        ])
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var discoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover new music"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var browseButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.configuration?.cornerStyle = .capsule
        button.tintColor = .label
        button.setTitle("Browse", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    lazy var discoverStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            discoverLabel,
            browseButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var personalizedLabel: UILabel = {
        let label = UILabel()
        label.text = "Personalized for you"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var exploreButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.configuration?.cornerStyle = .capsule
        button.tintColor = .label
        button.setTitle("Explore", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    lazy var personalizedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            personalizedLabel,
            exploreButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var personalizedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 160)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var popularSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular songs"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var popularSongsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configuration Methods
    private func configureUI() {
        backgroundColor = .systemBackground
        configureHeaderStackView()
        configureDiscoverStackView()
        configureDiscoverCollectionView()
        configurePersonalizedStackView()
        configurePersonalizedCollectionView()
        configurePopularSongsLabel()
        configurePopularSongsTableView()
    }
    
    private func configureHeaderStackView() {
        addSubview(headerStackView)
        headerStackView.anchor(top: safeAreaLayoutGuide.topAnchor,
                               leading: safeAreaLayoutGuide.leadingAnchor,
                               trailing: safeAreaLayoutGuide.trailingAnchor,
                               padding: .init(leading: 20,
                                              trailing: 20))
    }
    
    private func configureDiscoverStackView() {
        addSubview(discoverStackView)
        discoverStackView.anchor(top: headerStackView.bottomAnchor,
                               leading: safeAreaLayoutGuide.leadingAnchor,
                               trailing: safeAreaLayoutGuide.trailingAnchor,
                               padding: .init(top: 20,
                                              leading: 20,
                                              trailing: 20))
    }
    
    private func configureDiscoverCollectionView() {
        addSubview(discoverCollectionView)
        discoverCollectionView.anchor(top: discoverStackView.bottomAnchor,
                                      leading: safeAreaLayoutGuide.leadingAnchor,
                                      trailing: safeAreaLayoutGuide.trailingAnchor,
                                      padding: .init(top: 20,
                                                     leading: 20,
                                                     trailing: 20),
                                      size: .init(heightSize: 120))
    }
    
    private func configurePersonalizedStackView() {
        addSubview(personalizedStackView)
        personalizedStackView.anchor(top: discoverCollectionView.bottomAnchor,
                                leading: safeAreaLayoutGuide.leadingAnchor,
                                trailing: safeAreaLayoutGuide.trailingAnchor,
                                padding: .init(top: 20,
                                               leading: 20,
                                               trailing: 20))
    }
    
    private func configurePersonalizedCollectionView() {
        addSubview(personalizedCollectionView)
        personalizedCollectionView.anchor(top: personalizedStackView.bottomAnchor,
                                          leading: safeAreaLayoutGuide.leadingAnchor,
                                          trailing: safeAreaLayoutGuide.trailingAnchor,
                                          padding: .init(top: 20,
                                                         leading: 20,
                                                         trailing: 20),
                                          size: .init(heightSize: 160))
    }
    
    private func configurePopularSongsLabel() {
        addSubview(popularSongsLabel)
        popularSongsLabel.anchor(top: personalizedCollectionView.bottomAnchor,
                                 leading: safeAreaLayoutGuide.leadingAnchor,
                                 padding: .init(top: 20,
                                                leading: 20))
    }
    
    private func configurePopularSongsTableView() {
        addSubview(popularSongsTableView)
        popularSongsTableView.anchor(top: popularSongsLabel.bottomAnchor,
                                     leading: safeAreaLayoutGuide.leadingAnchor,
                                     bottom: safeAreaLayoutGuide.bottomAnchor,
                                     trailing: safeAreaLayoutGuide.trailingAnchor,
                                     padding: .init(leading: 20,
                                                    trailing: 20))
    }
    
    
}
