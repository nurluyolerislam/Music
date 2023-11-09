//
//  HomeVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: - Mocks
    let discoverCards : [MusicCollectionViewCellModel] = [
        .init(image: UIImage(named: "profileImage")!,
              firstLabelText: "Chill out",
              secondLabelText: "Study with"),
        .init(image: UIImage(named: "profileImage")!,
              firstLabelText: "Get jazzy",
              secondLabelText: "Enjoy a rainy"),
        .init(image: UIImage(named: "profileImage")!,
              firstLabelText: "Soundtrack",
              secondLabelText: "Rock out with")
    ]
    
    let personalizedCards : [MusicCollectionViewCellModel] = [
        .init(image: UIImage(named: "profileImage")!,
              firstLabelText: "Your top played",
              secondLabelText: "Discover new artists"),
        .init(image: UIImage(named: "profileImage")!,
              firstLabelText: "Best of",
              secondLabelText: "Office music for"),
        .init(image: UIImage(named: "profileImage")!,
              firstLabelText: "Best of",
              secondLabelText: "Office music for"),
        .init(image: UIImage(named: "profileImage")!,
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
    
    
    //MARK: - Variables
    lazy var homeView = HomeView()
    
    //MARK: - Lifecycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        addDelegatesAndDataSources()
    }
    
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        homeView.discoverCollectionView.register(MusicCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.personalizedCollectionView.register(MusicCollectionViewCell.self,
                                                     forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.popularSongsTableView.register(PopularSongsTableViewCell.self,
                                                forCellReuseIdentifier: PopularSongsTableViewCell.reuseID)
        
        homeView.discoverCollectionView.delegate = self
        homeView.personalizedCollectionView.delegate = self
        homeView.popularSongsTableView.dataSource = self
        homeView.discoverCollectionView.dataSource = self
        homeView.personalizedCollectionView.dataSource = self
    }
    
    //MARK: - Targets
    private func addTargets() {
        let profileImageGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                   action: #selector(profileImageTapped))
        homeView.profileImage.addGestureRecognizer(profileImageGestureRecognizer)
        
        homeView.browseButton.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
        
        homeView.exploreButton.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - @Actions
    @objc func profileImageTapped() {
        print("DEBUG: profileImage tapped")
    }
    
    @objc func browseButtonTapped() {
        print("DEBUG: browseButton tapped")
    }
    
    @objc func exploreButtonTapped(){
        print("DEBUG: exploreButton tapped")
    }
    
    
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.popularSongsTableView.dequeueReusableCell(withIdentifier: PopularSongsTableViewCell.reuseID) as! PopularSongsTableViewCell
        let song = popularSongs[indexPath.row]
        
        cell.songImageView.image = song.image
        cell.songNameLabel.text = song.songName
        cell.recommendationReason.text = song.albumName
        
        return cell
    }
    
}

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case homeView.discoverCollectionView:
            return discoverCards.count
        case homeView.personalizedCollectionView:
            return personalizedCards.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case homeView.discoverCollectionView:
            let cell = homeView.discoverCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                           for: indexPath) as! MusicCollectionViewCell
            let card = discoverCards[indexPath.row]
            cell.imageView.image = card.image
            cell.firstLabel.text = card.firstLabelText
            cell.secondLabel.text = card.secondLabelText
            return cell
        case homeView.personalizedCollectionView:
            let cell = homeView.personalizedCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                               for: indexPath) as! MusicCollectionViewCell
            let card = personalizedCards[indexPath.row]
            cell.imageView.image = card.image
            cell.firstLabel.text = card.firstLabelText
            cell.secondLabel.text = card.secondLabelText
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case homeView.discoverCollectionView:
            print("DEBUG: discoverCollectionView's \(discoverCards[indexPath.row].firstLabelText) tapped")
        case homeView.personalizedCollectionView:
            print("DEBUG: personalizedCollectionView's \(personalizedCards[indexPath.row].firstLabelText) tapped")
        default:
            print("DEBUG: Unrecognized collection view tapped")
        }
    }
    
}
