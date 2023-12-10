//
//  ProfileViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit

protocol ProfileVMInterface: AnyObject {
    var view: ProfileVCInterface? { get set }
    func viewDidLoad()
    func removeFromPlayList(at indexPath: IndexPath)
    func removeFromFavoriteList(at indexPath: IndexPath)
    func playListsDidSelectRow(at indexPath: IndexPath)
    func favoriteListsDidSelectRow(at indexPath: IndexPath)
}

final class ProfileViewModel {
    
    //MARK: - Variables
    var userName: String?
    var playlists: [UserPlaylist]?
    var userFavoriteTracks: [Track]?
    var view: ProfileVCInterface?
    let firestoreManager: FirestoreManagerProtocol
    lazy var firebaseAuthManager = FirebaseAuthManager()
    lazy var firebaseStorageManager = FirebaseStorageManager()
    
    init(firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared) {
        self.firestoreManager = firestoreManager
    }
    
    
    //MARK: - Helper Functions
    func getUserName() {
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
    
    func getUserPlaylists () {
        firestoreManager.getUserPlaylists { [weak self] playlists in
            guard let self else { return }
            self.playlists = playlists
            view?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func getUserFavoriteTracks () {
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
    
    func removeTrackFromFavorites(track: Track) {
        firestoreManager.removeTrackFromFavorites(track: track) { [weak self] in
            guard let self else { return }
            getUserFavoriteTracks()
            view?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func removePlaylist(playlist: UserPlaylist) {
        firestoreManager.removePlaylist(playlist: playlist) { [weak self] in
            guard let self else { return }
            getUserPlaylists()
            view?.updateTableView()
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
    
    func fetchUserPhoto() {
        view?.showProgressView()
        firebaseStorageManager.fetchUserImage() { [weak self] url in
            guard let self else { return }
            view?.updateUserPhoto(imageURL: url)
            view?.dismissProgressView()
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

}


extension ProfileViewModel: ProfileVMInterface {
 
    func viewDidLoad() {
        view?.configureViewDidLoad()
        getUserName()
        fetchUserPhoto()
    }
    
    func removeFromPlayList(at indexPath: IndexPath) {
        if let playlists = playlists {
            let playlist = playlists[indexPath.row]
            removePlaylist(playlist: playlist)
        }
    }
    
    func removeFromFavoriteList(at indexPath: IndexPath) {
        if let userFavoriteTracks = userFavoriteTracks {
            let track = userFavoriteTracks[indexPath.row]
            removeTrackFromFavorites(track: track)
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
    }
    
}
