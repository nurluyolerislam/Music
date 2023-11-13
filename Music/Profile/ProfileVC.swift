//
//  ProfileVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

final class ProfileVC: UIViewController {
    // MARK: - Properties
    lazy var profileView = ProfileView()
    lazy var viewModel = ProfileVM()
    
    //MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        configureSegmentedControll()
        configureNavigationBar()
    }
    
    //MARK: - UI Configuration
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureSegmentedControll(){
        profileView.segenmtedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        profileView.createPlaylistButton.addTarget(self, action: #selector(createPlaylistButtonTapped), for: .touchUpInside)
        profileView.createPlaylistPopup.createButton.addTarget(self, action: #selector(createPlaylistPopupCreateButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - @Actions
    @objc func segmentValueChanged() {
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            profileView.tableView.register(ProfilePlayListTableViewCell.self, forCellReuseIdentifier: ProfilePlayListTableViewCell.reuseID)
            viewModel.getPlaylists()
        case 1:
            profileView.tableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
            viewModel.getFavoriteTracks()
        default:
            break;
        }
    }
    
    @objc func createPlaylistButtonTapped(){
        present(profileView.createPlaylistPopup, animated: true)
    }
    
    @objc func createPlaylistPopupCreateButtonTapped(){
        guard let playlistName = profileView.createPlaylistPopup.textField.text else { return }
        if !playlistName.isEmpty {
            viewModel.createNewPlaylist(playlistName: playlistName)
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            return viewModel.playlists.count
            
        case 1:
            return viewModel.favoriteTracks.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            guard let cell = profileView.tableView.dequeueReusableCell(withIdentifier: ProfilePlayListTableViewCell.reuseID, for: indexPath) as? ProfilePlayListTableViewCell else {
                return UITableViewCell()
            }
            let playlist = viewModel.playlists[indexPath.row]
            
            if let imageURL = playlist.image {
                cell.songImageView.kf.setImage(with: URL(string: imageURL))
            }
            
            if let title = playlist.title {
                cell.playListName.text = title
            }
            
            if let tracks = playlist.tracks {
                cell.numberOfSound.text = "\(tracks.count.description) Tracks"
            } else {
                cell.numberOfSound.text = "0 Tracks"
            }
            
            return cell
            
        case 1:
            guard let cell = profileView.tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as? ProfileFavoriteTableViewCell else {
                return UITableViewCell()
            }
            let track = viewModel.favoriteTracks[indexPath.row]
            
            if let artist = track.artist {
                if let artistName = artist.name {
                    if let songName = track.title {
                        cell.songNameLabel.text = "\(artistName) - \(songName)"
                    }
                }
            }
            
            if let album = track.album {
                if let imageURL = album.coverXl {
                    cell.songImageView.kf.setImage(with: URL(string: imageURL))
                }
                
                if let albumName = album.title {
                    cell.recommendationReason.text = albumName
                }
            }
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            return
            
        case 1:
            let song = viewModel.favoriteTracks[indexPath.row]
            let vc = PlayerVC(track: song)
            vc.modalPresentationStyle = .pageSheet
            self.present(vc, animated: true)
            
        default:
            return
            
        }
        
    }
}

extension ProfileVC: ProfileVMDelegate {
    func updateUI() {
        profileView.tableView.reloadData()
    }
    
    func createPlaylistPopupDismiss() {
        profileView.createPlaylistPopup.dismiss(animated: true)
    }
}
