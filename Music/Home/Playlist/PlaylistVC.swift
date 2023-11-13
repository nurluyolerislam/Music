//
//  PlaylistVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 12.11.2023.
//

import UIKit
import Kingfisher

class PlaylistVC: UIViewController {
    
    //MARK: - Variables
    let playlistView = PlaylistView()
    let viewModel: PlaylistViewModel
    
    //MARK: - Initializers
    init(playlistURL: String, manager: DeezerAPIManager) {
        self.viewModel = PlaylistViewModel(playlistURL: playlistURL, manager: manager)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        addDelegatesAndDataSources()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = playlistView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        playlistView.tableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        
        playlistView.tableView.dataSource = self
        playlistView.tableView.delegate = self
    }
    
}


extension PlaylistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let response = viewModel.data {
            if let tracks = response.data {
                return tracks.count
            }
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistView.tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as! ProfileFavoriteTableViewCell
        
        if let response = viewModel.data {
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

extension PlaylistVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let response = viewModel.data {
            
            if let songs = response.data {
                
                let song = songs[indexPath.row]
                let vc = PlayerVC(track: song)
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
                
            }
        }
    }
}


extension PlaylistVC: PlaylistViewModelDelegate {
    func updateUI() {
        playlistView.tableView.reloadData()
    }
}
