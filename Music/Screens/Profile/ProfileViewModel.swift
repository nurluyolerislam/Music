//
//  ProfileViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit

protocol ProfileVMInterface {
    var view: ProfileVCInterface? { get set }
    func viewDidLoad()
    func getUserPlaylists()
    func getUserFavoriteTracks()
    func createNewPlaylist(playlistName: String)
    func uploadUserPhoto(imageData: UIImage)
    func logout(completion: @escaping () -> Void )
    func removePlaylist(at indexPath: IndexPath)
    func removeTrackFromFavorites(at indexPath: IndexPath)
    func playListsDidSelectRow(at indexPath: IndexPath)
    
    func favoriteListsDidSelectRow(at indexPath: IndexPath)
}

final class ProfileViewModel {
    
    //MARK: - Variables
    weak var view: ProfileVCInterface?
    var userName: String?
    var playlists: [UserPlaylist]?
    var userFavoriteTracks: [Track]?
    private let firestoreManager: FirestoreManagerProtocol
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseStorageManager: FirebaseStorageManagerProtocol
    
    init(view: ProfileVCInterface, firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared, firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared,firebaseStorageManager: FirebaseStorageManagerProtocol = FirebaseStorageManager.shared ) {
        self.firestoreManager = firestoreManager
        self.firebaseAuthManager = firebaseAuthManager
        self.firebaseStorageManager = firebaseStorageManager
        
        self.view = view
    }
    
    
    //MARK: - Helper Functions
    private func getUserName() {
        view?.showProgressView()
        firestoreManager.getUserName { [weak self] userName in
            guard let self else { return }
            self.userName = userName
            view?.updateUserName()
            view?.dismissProgressView()
        } onError: { [weak self] error in
            guard let self else { return }
            print(error)
            view?.dismissProgressView()
        }
    }
    
    private func fetchUserPhoto() {
        view?.showProgressView()
        firebaseStorageManager.fetchUserImage() { [weak self] url in
            guard let self else { return }
            view?.updateUserPhoto(imageURL: url)
            view?.dismissProgressView()
        } onError: { error in
            print(error)
        }
    }
    
}


extension ProfileViewModel: ProfileVMInterface {
    
    func viewDidLoad() {
        view?.configureNavigationBar()
        view?.addTargets()
        view?.prepareTableView()
        getUserName()
        fetchUserPhoto()
    }
    
    func removeTrackFromFavorites(at indexPath: IndexPath) {
        guard let userFavoriteTracks else { return }
        let track = userFavoriteTracks[indexPath.row]
        firestoreManager.removeTrackFromFavorites(track: track) { [weak self] in
            guard let self else { return }
            getUserFavoriteTracks()
            view?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func getUserPlaylists () {
        firestoreManager.getUserPlaylists { [weak self] playlists in
            guard let self else { return }
            self.playlists = playlists
            view?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func getUserFavoriteTracks() {
        firestoreManager.getUserFavoriteTracks { [weak self] tracks in
            guard let self else { return }
            userFavoriteTracks = tracks
            view?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func createNewPlaylist(playlistName: String) {
        firestoreManager.createNewPlaylist(playlistName: playlistName) { [weak self] in
            guard let self else { return }
            getUserPlaylists()
            view?.dismissCreatePlaylistPopup()
        } onError: { error in
            print(error)
        }
    }
    
    func uploadUserPhoto(imageData: UIImage) {
        firebaseStorageManager.uploadUserImage(image: imageData) { [weak self] in
            guard let self else { return }
            fetchUserPhoto()
        } onError: { error in
            print(error)
        }
    }
    
    func logout(completion: @escaping () -> Void ) {
        firebaseAuthManager.signOut {
            completion()
        } onError: { error in
            print(error)
        }
    }
    
    func removePlaylist(at indexPath: IndexPath) {
        guard let playlists = playlists else  { return }
        let playlist = playlists[indexPath.row]
        
        firestoreManager.removePlaylist(playlist: playlist) { [weak self] in
            guard let self else { return }
            getUserPlaylists()
            view?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func playListsDidSelectRow(at indexPath: IndexPath) {
        if let playlists = playlists {
            let playlist = playlists[indexPath.row]
            let playlistVC = PlaylistVC(userPlaylist: playlist)
            playlistVC.title = playlist.title
            view?.pushVC(vc: playlistVC)
        }
    }
    
    func favoriteListsDidSelectRow(at indexPath: IndexPath) {
        guard let userFavoriteTracks else { return }
        let track = userFavoriteTracks[indexPath.row]
        view?.presentVC(vc: PlayerVC(track: track))
    }
    
}
