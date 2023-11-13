//
//  HomeVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit
import Kingfisher

protocol HomeVCProtocol: AnyObject {
    func profileImageTapped()
}

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
    weak var delegate: HomeVCProtocol?
    let viewModel = HomeViewModel()
    
    //MARK: - Lifecycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        addDelegatesAndDataSources()
        configureUI()
        viewModel.delegate = self
    }
    
    //MARK: - Configuration Methods
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
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
        self.delegate?.profileImageTapped()
    }
    
    @objc func browseButtonTapped() {
        let discoverVC = DiscoverVC(viewModel: viewModel)
        navigationController?.pushViewController(discoverVC, animated: true)

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
        cell.albumNameLabel.text = song.albumName
        
        return cell
    }
    
}

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case homeView.discoverCollectionView:
            return 5
            
        case homeView.personalizedCollectionView:
            return 5
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case homeView.discoverCollectionView:
            let cell = homeView.discoverCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                           for: indexPath) as! MusicCollectionViewCell
            
            if let response = viewModel.data {
                if let playlists = response.data {
                    let playlist = playlists[indexPath.row]
                    
                    if let imageURL = playlist.pictureXl {
                        cell.imageView.kf.setImage(with: URL(string: imageURL)!)
                    }
                    
                    if let title = playlist.title {
                        cell.label.text = title
                    }
                }
            }
            
            return cell
        case homeView.personalizedCollectionView:
            let cell = homeView.personalizedCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
            
                                                                               for: indexPath) as! MusicCollectionViewCell

            if let response = viewModel.dataGenres {
                if let genresData = response.data {
                    let genresLists = genresData[indexPath.row]
                    
                    if let imageURL = genresLists.pictureXl {
                        cell.imageView.kf.setImage(with: URL(string: imageURL)!)
                    }
                    
                    if let name = genresLists.name {
                        cell.label.text = name
                    }
                }
            }
//            let card = personalizedCards[indexPath.row]
//            cell.imageView.image = card.image
//            cell.label.text = card.firstLabelText
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
            
                if let response = viewModel.data {
                    if let playlists = response.data {
                        let playlist = playlists[indexPath.row]
                        
                        if let playlistURL = playlist.tracklist {
                            navigationController?.pushViewController(PlaylistVC(playlistURL: playlistURL, manager: viewModel.manager), animated: true)
                        }
                    }
                }
            
        case homeView.personalizedCollectionView:
            if let response = viewModel.dataGenres {
                if let genres = response.data {
                    let genre = genres[indexPath.row]
                    
                    if let genresID = genre.id {
                        let id = String(genresID)
                        
                        navigationController?.pushViewController(GenreArtistsVC(genreId: id, manager: viewModel.manager), animated: true)
                        
                    }
                }
            }
        
        default:
            print("DEBUG: Unrecognized collection view tapped")
        }
    }
    
}

extension HomeVC: HomeViewModelDelegate {
    func updateUI() {
        homeView.discoverCollectionView.reloadData()
        homeView.personalizedCollectionView.reloadData()
    }
}
