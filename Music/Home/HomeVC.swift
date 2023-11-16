//
//  HomeVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit
import Kingfisher

// MARK: - HomeViewInterface
protocol HomeViewInterface: AnyObject {
    func showLoadingIndicator()
    func dismissLoadingIndicator()
}

class HomeVC: UIViewController {
    
    //MARK: - Variables
    lazy var homeView = HomeView()
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
        viewModel.view = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK: - Configuration Methods
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Home"
    }
    
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        homeView.discoverCollectionView.register(MusicCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.personalizedCollectionView.register(MusicCollectionViewCell.self,
                                                     forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.popularSongsTableView.register(ProfileFavoriteTableViewCell.self,
                                                forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        
        homeView.discoverCollectionView.delegate = self
        homeView.personalizedCollectionView.delegate = self
        homeView.popularSongsTableView.delegate = self
        homeView.discoverCollectionView.dataSource = self
        homeView.personalizedCollectionView.dataSource = self
        homeView.popularSongsTableView.dataSource = self
    }
    
    
    //MARK: - Targets
    private func addTargets() {
        homeView.browseButton.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
        homeView.exploreButton.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - @Actions
    @objc func browseButtonTapped() {
        let discoverVC = DiscoverVC(viewModel: viewModel)
        navigationController?.pushViewController(discoverVC, animated: true)
        
    }
    
    @objc func exploreButtonTapped(){
        let genresVC = GenresVC(viewModel: viewModel)
        navigationController?.pushViewController(genresVC, animated: true)
    }
    
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let popularSongsResponse = viewModel.popularSongsResponse {
            if let tracks = popularSongsResponse.data {
                return tracks.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.popularSongsTableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as! ProfileFavoriteTableViewCell
        
        if let response = viewModel.popularSongsResponse {
            if let tracks = response.data {
                let track = tracks[indexPath.row]
                
                if let songName = track.title {
                    cell.songNameLabel.text = songName
                }
                
                if let album = track.album {
                    if let imageURL = album.coverXl {
                        cell.songImageView.kf.setImage(with: URL(string: imageURL))
                    }
                    
                    if let albumName = album.title {
                        cell.recommendationReason.text = albumName
                    }
                }
            }
        }
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
            
            if let response = viewModel.radioResponse {
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
            
            if let response = viewModel.genresResponse {
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
            
            if let response = viewModel.radioResponse {
                if let playlists = response.data {
                    let playlist = playlists[indexPath.row]
                    
                    if let playlistURL = playlist.tracklist {
                        let playlistVC = PlaylistVC(playlistURL: playlistURL, deezerAPIManager: viewModel.manager)
                        playlistVC.title = playlist.title
                        navigationController?.pushViewController(playlistVC, animated: true)
                    }
                }
            }
            
        case homeView.personalizedCollectionView:
            if let response = viewModel.genresResponse {
                if let genres = response.data {
                    let genre = genres[indexPath.row]
                    
                    if let genresID = genre.id {
                        let genresArtistsVC = GenreArtistsVC(genreId: genresID.description, manager: viewModel.manager)
                        genresArtistsVC.title = genre.name
                        navigationController?.pushViewController(genresArtistsVC, animated: true)
                        
                    }
                }
            }
            
        default:
            return
        }
    }
    
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let response = viewModel.popularSongsResponse {
            if let songs = response.data {
                let song = songs[indexPath.row]
                let vc = PlayerVC(track: song)
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
            }
        }
    }
}

extension HomeVC: HomeViewModelDelegate {
    func updateUI() {
        homeView.discoverCollectionView.reloadData()
        homeView.personalizedCollectionView.reloadData()
        homeView.popularSongsTableView.reloadData()
    }
}


// MARK: - HomeViewInterface
extension HomeVC: HomeViewInterface {
    // Displays the loading indicator.
    func showLoadingIndicator() {
        showLoading()
    }
    // Dismisses the loading indicator.
    func dismissLoadingIndicator() {
        dismissLoading()
    }
}
