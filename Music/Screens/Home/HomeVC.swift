//
//  HomeVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

final class HomeVC: UIViewController {
    
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
        homeView.genresCollectionView.register(MusicCollectionViewCell.self,
                                                     forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.popularSongsTableView.register(ProfileFavoriteTableViewCell.self,
                                                forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        
        homeView.discoverCollectionView.delegate = self
        homeView.genresCollectionView.delegate = self
        homeView.popularSongsTableView.delegate = self
        homeView.discoverCollectionView.dataSource = self
        homeView.genresCollectionView.dataSource = self
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
                cell.updateUI(track: track)
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
            
        case homeView.genresCollectionView:
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
                    cell.updateUI(playlist: playlist)
                }
            }
            
            return cell
            
        case homeView.genresCollectionView:
            let cell = homeView.genresCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                               
                                                                               for: indexPath) as! MusicCollectionViewCell
            
            if let response = viewModel.genresResponse {
                if let genresPlaylists = response.data {
                    let genresPlaylist = genresPlaylists[indexPath.row]
                    cell.updateUI(genresPlaylist: genresPlaylist)
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
            
        case homeView.genresCollectionView:
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
    func showProgressView() {
        showLoading()
    }
    
    func dismissProgressView() {
        dismissLoading()
    }
    
    func updateUI() {
        homeView.discoverCollectionView.reloadData()
        homeView.genresCollectionView.reloadData()
        homeView.popularSongsTableView.reloadData()
    }    
}
