//
//  HomeView.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

class HomeView: UIView {
    
    //MARK: - Mocks
    let discoverCards : [MusicCollectionViewCellModel] = [MusicCollectionViewCellModel(image: UIImage(named: "profileImage")!,
                                                                   firstLabelText: "Chill out",
                                                                   secondLabelText: "Study with"),
                                                          MusicCollectionViewCellModel(image: UIImage(named: "profileImage")!,
                                                                   firstLabelText: "Get jazzy",
                                                                   secondLabelText: "Enjoy a rainy"),
                                                          MusicCollectionViewCellModel(image: UIImage(named: "profileImage")!,
                                                                   firstLabelText: "Soundtrack",
                                                                   secondLabelText: "Rock out with")
    ]
    
    let personalizedCards : [MusicCollectionViewCellModel] = [MusicCollectionViewCellModel(image: UIImage(named: "profileImage")!,
                                                                       firstLabelText: "Your top played",
                                                                       secondLabelText: "Discover new artists"),
                                                              MusicCollectionViewCellModel(image: UIImage(named: "profileImage")!,
                                                                       firstLabelText: "Best of",
                                                                       secondLabelText: "Office music for")
    ]
    
    let popularSongs: [PopularSongsTableViewCellModel] = [
        .init(image: UIImage(named: "profileImage")!,
              songName: "California living vibes",
              albumName: "Trending tracks by Tom"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "On the top charts",
              albumName: "Recommended tracks by Alma"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas")
    ]
    
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
        let button = UIButton(configuration: .plain())
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MusicCollectionViewCell.self,
                                forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        return collectionView
    }()
    
    lazy var personalizedLabel: UILabel = {
        let label = UILabel()
        label.text = "Personalized for you"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var exploreButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("Explore", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MusicCollectionViewCell.self,
                                forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
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
        tableView.dataSource = self
        tableView.register(PopularSongsTableViewCell.self,
                           forCellReuseIdentifier: PopularSongsTableViewCell.reuseID)
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
    
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        browseButton.layer.borderColor = UIColor.label.cgColor
        browseButton.layer.borderWidth = 2
        browseButton.layer.cornerRadius = 20
        
        exploreButton.layer.borderColor = UIColor.label.cgColor
        exploreButton.layer.borderWidth = 2
        exploreButton.layer.cornerRadius = 20
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
                                      size: .init(heightSize: 150))
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
                                          size: .init(heightSize: 150))
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

extension HomeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popularSongsTableView.dequeueReusableCell(withIdentifier: PopularSongsTableViewCell.reuseID) as! PopularSongsTableViewCell
        let song = popularSongs[indexPath.row]
        
        cell.songImageView.image = song.image
        cell.songNameLabel.text = song.songName
        cell.recommendationReason.text = song.albumName
        
        return cell
    }
    
    
}

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case discoverCollectionView:
            return discoverCards.count
        case personalizedCollectionView:
            return personalizedCards.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = discoverCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                              for: indexPath) as! MusicCollectionViewCell
        switch collectionView {
        case discoverCollectionView:
            let card = discoverCards[indexPath.row]
            cell.imageView.image = card.image
            cell.firstLabel.text = card.firstLabelText
            cell.secondLabel.text = card.secondLabelText
        case personalizedCollectionView:
            let card = personalizedCards[indexPath.row]
            cell.imageView.image = card.image
            cell.firstLabel.text = card.firstLabelText
            cell.secondLabel.text = card.secondLabelText
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case discoverCollectionView:
            print("DEBUG: discoverCollectionView's \(discoverCards[indexPath.row].firstLabelText) tapped")
        case personalizedCollectionView:
            print("DEBUG: personalizedCollectionView's \(personalizedCards[indexPath.row].firstLabelText) tapped")
        default:
            print("DEBUG: Unrecognized collection view tapped")
        }
    }
}

#Preview {
    HomeVC()
}
