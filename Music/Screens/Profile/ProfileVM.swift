//
//  ProfileVM.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit.UIImage

protocol ProfileVMDelegate: AnyObject {
    func updateUserPhoto(imageURL: URL)
    func updateUserName()
    func updateTableView()
    func dismissCreatePlaylistPopup()
    func showProgressView()
    func dismissProgressView()
}

class ProfileVM {
    
    //MARK: - Variables
    var userName: String?
    var playlists: [UserPlaylist]?
    var userFavoriteTracks: [Track]?
    weak var delegate: ProfileVMDelegate?
    lazy var firestoreManager = FirestoreManager()
    lazy var firebaseAuthManager = FirebaseAuthManager()
    lazy var firebaseStorageManager = FirebaseStorageManager()
    
    
    //MARK: - Helper Functions
    func getUserName() {
        delegate?.showProgressView()
        firestoreManager.getUserName { [weak self] userName in
            guard let self else { return }
            self.userName = userName
            delegate?.updateUserName()
            delegate?.dismissProgressView()
        } onError: { [weak self] error in
            guard let self else { return }
            print(error)
            delegate?.dismissProgressView()
        }
    }
    
    func getUserPlaylists () {
        firestoreManager.getUserPlaylists { [weak self] playlists in
            guard let self else { return }
            self.playlists = playlists
            delegate?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func getUserFavoriteTracks () {
        firestoreManager.getUserFavoriteTracks { [weak self] tracks in
            guard let self else { return }
            userFavoriteTracks = tracks
            delegate?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func createNewPlaylist(playlistName: String) {
        firestoreManager.createNewPlaylist(playlistName: playlistName) { [weak self] in
            guard let self else { return }
            getUserPlaylists()
            delegate?.dismissCreatePlaylistPopup()
        } onError: { error in
            print(error)
        }
    }
    
    func removeTrackFromFavorites(track: Track) {
        firestoreManager.removeTrackFromFavorites(track: track) { [weak self] in
            guard let self else { return }
            getUserFavoriteTracks()
            delegate?.updateTableView()
        } onError: { error in
            print(error)
        }
    }
    
    func removePlaylist(playlist: UserPlaylist) {
        firestoreManager.removePlaylist(playlist: playlist) { [weak self] in
            guard let self else { return }
            getUserPlaylists()
            delegate?.updateTableView()
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
        delegate?.showProgressView()
        firebaseStorageManager.fetchUserImage() { [weak self] url in
            guard let self else { return }
            delegate?.updateUserPhoto(imageURL: url)
            delegate?.dismissProgressView()
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
