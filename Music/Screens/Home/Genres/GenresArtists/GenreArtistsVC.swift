//
//  GenreArtistsVC.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//

import UIKit

final class GenreArtistsVC: UIViewController {
    
    //MARK: - Variables
    let genreArtistsView = GenreArtistsView()
    let viewModel: GenreArtistsViewModel?
    
    
    //MARK: - Initializers
    init(genreId: String, manager: DeezerAPIManager) {
        self.viewModel = GenreArtistsViewModel(genreId: genreId, manager: manager)
        super.init(nibName: nil, bundle: nil)
        viewModel?.delegate = self
        addDelegatesAndDataSources()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        view = genreArtistsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        genreArtistsView.collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        
        genreArtistsView.collectionView.dataSource = self
        genreArtistsView.collectionView.delegate = self
    }
    
}

extension GenreArtistsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            if let response = viewModel.data {
                if let artists = response.data {
                    return artists.count
                }
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID, for: indexPath) as! MusicCollectionViewCell
        
        if let viewModel {
            if let response = viewModel.data {
                if let artists = response.data {
                    let artist = artists[indexPath.row]
                    cell.updateUI(artist: artist)
                }
            }
        }
        return cell
    }
    
}

extension GenreArtistsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel {
            if let response = viewModel.data {
                if let artists = response.data {
                    let artist = artists[indexPath.row]
                    
                    if let playlistURL = artist.tracklist {
                        let playlistVC = PlaylistVC(playlistURL: playlistURL, deezerAPIManager: viewModel.manager)
                        playlistVC.title = artist.name
                        navigationController?.pushViewController(playlistVC, animated: true)
                    }
                }
            }
        }
    }
}

extension GenreArtistsVC: GenreArtistsViewModelDelegate {
    func updateUI() {
        genreArtistsView.collectionView.reloadData()
    }
}
