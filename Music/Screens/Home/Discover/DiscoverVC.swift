//
//  DiscoverVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit

final class DiscoverVC: UIViewController {
    
    //MARK: - Variables
    lazy var discoverView = DiscoverView()
    let viewModel: HomeViewModel?
    
    
    //MARK: - Initializers
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addDelegatesAndDataSources()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = discoverView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    //MARK: - Helper Functions
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Discover"
    }
    
    private func addDelegatesAndDataSources() {
        discoverView.collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        
        discoverView.collectionView.dataSource = self
        discoverView.collectionView.delegate = self
    }

}


extension DiscoverVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            if let response = viewModel.radioResponse {
                if let playlists = response.data {
                    return playlists.count
                }
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID, for: indexPath) as! MusicCollectionViewCell
        
        if let viewModel = viewModel {
            if let response = viewModel.radioResponse {
                if let playlists = response.data {
                    let playlist = playlists[indexPath.row]
                    cell.updateUI(playlist: playlist)
                }
            }
        }
        
        return cell
    }
    
}

extension DiscoverVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
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
        }
    }
}
