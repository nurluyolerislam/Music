//
//  ProfileVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

final class ProfileVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
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
    override func loadView() {
        super.loadView()
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegatesAndDataSources()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserName()
        viewModel.fetchUserPhoto()
        
        navigationController?.isNavigationBarHidden = true
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            viewModel.getUserPlaylists()
        case 1:
            viewModel.getUserFavoriteTracks()
        default: return
        }
    }
    
    //MARK: - UI Configuration
    private func configureUI() {
        configureNavigationBar()
        configureSegmentedControll()
    }
    
    private func configureNavigationBar() {
        title = "Profile"
    }
    
    private func configureSegmentedControll(){
        profileView.segenmtedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        profileView.createPlaylistButton.addTarget(self, action: #selector(createPlaylistButtonTapped), for: .touchUpInside)
        profileView.createPlaylistPopup.createButton.addTarget(self, action: #selector(createPlaylistPopupCreateButtonTapped), for: .touchUpInside)
        
        profileView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        profileView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
    
    
    //MARK: - @Actions
    @objc func segmentValueChanged() {
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            profileView.tableView.register(ProfilePlayListTableViewCell.self, forCellReuseIdentifier: ProfilePlayListTableViewCell.reuseID)
            viewModel.getUserPlaylists()
            profileView.createPlaylistButton.isHidden = false
        case 1:
            profileView.tableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
            viewModel.getUserFavoriteTracks()
            profileView.createPlaylistButton.isHidden = true
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
    
    @objc func  editButtonTapped() {
        print("------->>>>>> DEBUG: ")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        viewModel.uploadUserPhoto(imageData: (image!))
        self.dismiss(animated: true)
}
    
    @objc func logoutButtonTapped(){
        viewModel.logout {
            let loginVC = LoginVC()
            let nav = UINavigationController(rootViewController: loginVC)
            self.view.window?.rootViewController = nav
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            if let playlists = viewModel.playlists {
                return playlists.count
            }
        case 1:
            if let userFavoriteTracks = viewModel.userFavoriteTracks {
                return userFavoriteTracks.count
            }
            
        default:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            let cell = profileView.tableView.dequeueReusableCell(withIdentifier: ProfilePlayListTableViewCell.reuseID) as! ProfilePlayListTableViewCell
            
            if let playlists = viewModel.playlists {
                let playlist = playlists[indexPath.row]
                if let title = playlist.title {
                    cell.playListName.text = title
                }
                if let trackCount = playlist.trackCount {
                    cell.numberOfSound.text = "\(trackCount) Tracks"
                }
            }
            return cell
            
        case 1:
            let cell = profileView.tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID) as! ProfileFavoriteTableViewCell
            
            if let userFavoriteTracks = viewModel.userFavoriteTracks {
                let track = userFavoriteTracks[indexPath.row]
                
                if let artist = track.artist,
                   let songName = track.title {
                    if let artistName = artist.name {
                        cell.songNameLabel.text = "\(artistName) - \(songName)"
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
            if let playlists = viewModel.playlists {
                let playlist = playlists[indexPath.row]
                let playlistVC = PlaylistVC(userPlaylist: playlist, firestoreManager: viewModel.firestoreManager)
                playlistVC.title = playlist.title
                navigationController?.pushViewController(playlistVC, animated: true)
            }
            
        case 1:
            if let userFavoriteTracks = viewModel.userFavoriteTracks {
                let track = userFavoriteTracks[indexPath.row]
                let vc = PlayerVC(track: track)
                vc.viewModel?.delegate = self
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
            }
            
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch profileView.segenmtedControl.selectedSegmentIndex {
        case 0:
            let removePlaylist = UIContextualAction(style: .destructive,
                                                    title: "Remove") { [weak self] action, view, bool in
                guard let self else { return }
                if let playlists = viewModel.playlists {
                    let playlist = playlists[indexPath.row]
                    viewModel.removePlaylist(playlist: playlist)
                }
            }
            return UISwipeActionsConfiguration(actions: [removePlaylist])
            
        case 1:
            let removeFromFavoritesAction = UIContextualAction(style: .destructive,
                                                               title: "Remove") { [weak self] action, view, bool in
                guard let self else { return }
                if let userFavoriteTracks = viewModel.userFavoriteTracks {
                    let track = userFavoriteTracks[indexPath.row]
                    viewModel.removeTrackFromFavorites(track: track)
                }
            }
            return UISwipeActionsConfiguration(actions: [removeFromFavoritesAction])
            
        default:
            return nil
        }
    }
}

extension ProfileVC: ProfileVMDelegate {
    func updateUserPhoto(imageURL: URL) {
        profileView.userImage.kf.setImage(with: imageURL)
    }
    
    
    func updateUserName() {
        profileView.userName.text = viewModel.userName
    }
    
    func updateTableView() {
        profileView.tableView.reloadData()
    }
    
    func dismissCreatePlaylistPopup() {
        profileView.createPlaylistPopup.dismiss(animated: true)
    }
}

extension ProfileVC: PlayerVMDelegate {
    func updateFavorites() {
        if profileView.segenmtedControl.selectedSegmentIndex == 1 {
            viewModel.getUserFavoriteTracks()
        }
    }
}
