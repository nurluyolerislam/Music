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
        let button = UIButton(configuration: .plain())
        button.setTitle("Browse", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        return button
    }()
    
    lazy var browseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            discoverLabel,
            browseButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var browseContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            card1,
            card2,
            card3
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var card1: MusicCardView = {
        let card = MusicCardView(image: UIImage(named: "profileImage")!,
                                 title: "Chill out",
                                 subtitle: "Study with")
        return card
    }()
    
    lazy var card2: MusicCardView = {
        let card = MusicCardView(image: UIImage(named: "profileImage")!,
                                 title: "Get jazzy",
                                 subtitle: "Enjoy a rainy")
        return card
    }()
    
    lazy var card3: MusicCardView = {
        let card = MusicCardView(image: UIImage(named: "profileImage")!,
                                 title: "Soundtrack",
                                 subtitle: "Rock out with")
        return card
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
    
    lazy var exploreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            personalizedLabel,
            exploreButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var exploreContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            card4,
            card5
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var card4: MusicCardView = {
        let card = MusicCardView(image: UIImage(named: "profileImage")!,
                                 title: "Your top played",
                                 subtitle: "Discover new artists")
        return card
    }()
    
    lazy var card5: MusicCardView = {
        let card = MusicCardView(image: UIImage(named: "profileImage")!,
                                 title: "Best of",
                                 subtitle: "Officce music for")
        return card
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
    
    
    //MARK: - Helper Functions
    private func configureUI() {
        backgroundColor = .systemBackground
        configureHeaderStackView()
        configureBrowseStackView()
        configureBrowseContentStackView()
        configureExploreStackView()
        configureExploreContentStackView()
        configurePopularSongsLabel()
        configurePopularSongsTableView()
    }
    
    private func configureHeaderStackView() {
        addSubview(headerStackView)
        headerStackView.anchor(top: safeAreaLayoutGuide.topAnchor,
                               leading: safeAreaLayoutGuide.leadingAnchor,
                               trailing: safeAreaLayoutGuide.trailingAnchor,
                               padding: .init(leading: 20, trailing: 20))
    }
    
    private func configureBrowseStackView() {
        addSubview(browseStackView)
        browseStackView.anchor(top: headerStackView.bottomAnchor,
                                 leading: safeAreaLayoutGuide.leadingAnchor,
                                 trailing: safeAreaLayoutGuide.trailingAnchor,
                                 padding: .init(top: 20,
                                                leading: 20,
                                               trailing: 20))
    }
    
    private func configureBrowseContentStackView() {
        addSubview(browseContentStackView)
        browseContentStackView.anchor(top: browseStackView.bottomAnchor,
                                 leading: safeAreaLayoutGuide.leadingAnchor,
                                 trailing: safeAreaLayoutGuide.trailingAnchor,
                                 padding: .init(top: 20,
                                                leading: 20,
                                                trailing: 20),
                                 size: .init(heightSize: 150))
    }
    
    private func configureExploreStackView() {
        addSubview(exploreStackView)
        exploreStackView.anchor(top: browseContentStackView.bottomAnchor,
                                leading: safeAreaLayoutGuide.leadingAnchor,
                                trailing: safeAreaLayoutGuide.trailingAnchor,
                                padding: .init(top: 20,
                                               leading: 20,
                                               trailing: 20))
    }
    
    private func configureExploreContentStackView() {
        addSubview(exploreContentStackView)
        exploreContentStackView.anchor(top: exploreStackView.bottomAnchor,
                                 leading: safeAreaLayoutGuide.leadingAnchor,
                                 trailing: safeAreaLayoutGuide.trailingAnchor,
                                 padding: .init(top: 20,
                                                leading: 20,
                                                trailing: 20),
                                 size: .init(heightSize: 150))
    }
    
    private func configurePopularSongsLabel() {
        addSubview(popularSongsLabel)
        popularSongsLabel.anchor(top: exploreContentStackView.bottomAnchor,
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popularSongsTableView.dequeueReusableCell(withIdentifier: PopularSongsTableViewCell.reuseID) as! PopularSongsTableViewCell
        return cell
    }
    
    
}

#Preview {
    HomeVC()
}
