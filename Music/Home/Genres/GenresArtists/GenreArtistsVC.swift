//
//  GenreArtistsVC.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//

import UIKit
import Kingfisher

class GenreArtistsVC: UIViewController {
    
    //MARK: - Variables
    let genreArtistsView = GenreArtistsView()
    let viewModel: GenreArtistsVM?
    
    
    //MARK: - Initializers
    init(genreId: String, manager: DeezerAPIManager) {
        self.viewModel = GenreArtistsVM(genreId: genreId, manager: manager)
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
        
        if let viewModel = viewModel {
            if let response = viewModel.data {
                if let artists = response.data {
                    let artist = artists[indexPath.row]
                    
                    if let imageURL = artist.pictureXl {
                        cell.imageView.kf.setImage(with: URL(string: imageURL)!)
                    }
                    
                    if let artistName = artist.name {
                        cell.label.text = artistName
                    }
                }
            }
        }
        return cell
    }
    
}

extension GenreArtistsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            if let response = viewModel.data {
                if let artists = response.data {
                    let artist = artists[indexPath.row]
                    
                    if let playlistURL = artist.tracklist {
                        let playlistVC = PlaylistVC(playlistURL: playlistURL, manager: viewModel.manager)
                        playlistVC.title = artist.name
                        navigationController?.pushViewController(playlistVC, animated: true)
                    }
                }
            }
        }
    }
}

extension GenreArtistsVC: GenreArtistsVMDelegate {
    func updateUI() {
        genreArtistsView.collectionView.reloadData()
    }
}
