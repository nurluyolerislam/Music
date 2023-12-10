//
//  HomeView.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

final class HomeView: UIView {
    
    //MARK: - UI Elements
    private lazy var discoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover new music"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var browseButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.configuration?.cornerStyle = .capsule
        button.anchor(size: .init(widthSize: 100))
        button.tintColor = .label
        button.setTitle("Browse", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private lazy var discoverStackView: UIStackView = {
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
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.text = "Genres"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var exploreButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.configuration?.cornerStyle = .capsule
        button.anchor(size: .init(widthSize: 100))
        button.tintColor = .label
        button.setTitle("Explore", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private lazy var genresStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            genresLabel,
            exploreButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var popularSongsLabel: UILabel = {
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
        configureDiscoverStackView()
        configureDiscoverCollectionView()
        configureGenresStackView()
        configureGenresCollectionView()
        configurePopularSongsLabel()
        configurePopularSongsTableView()
    }
    
    private func configureDiscoverStackView() {
        addSubview(discoverStackView)
        discoverStackView.anchor(top: safeAreaLayoutGuide.topAnchor,
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
                                      size: .init(heightSize: 100))
    }
    
    private func configureGenresStackView() {
        addSubview(genresStackView)
        genresStackView.anchor(top: discoverCollectionView.bottomAnchor,
                                leading: safeAreaLayoutGuide.leadingAnchor,
                                trailing: safeAreaLayoutGuide.trailingAnchor,
                                padding: .init(top: 20,
                                               leading: 20,
                                               trailing: 20))
    }
    
    private func configureGenresCollectionView() {
        addSubview(genresCollectionView)
        genresCollectionView.anchor(top: genresStackView.bottomAnchor,
                                          leading: safeAreaLayoutGuide.leadingAnchor,
                                          trailing: safeAreaLayoutGuide.trailingAnchor,
                                          padding: .init(top: 20,
                                                         leading: 20,
                                                         trailing: 20),
                                          size: .init(heightSize: 100))
    }
    
    private func configurePopularSongsLabel() {
        addSubview(popularSongsLabel)
        popularSongsLabel.anchor(top: genresCollectionView.bottomAnchor,
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
                                     padding: .init(top: 20,
                                     leading: 20,
                                     trailing: 20))
    }
    
    
}
