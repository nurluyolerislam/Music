//
//  ProfileVM.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit
import FirebaseStorage

protocol ProfileVMDelegate: AnyObject {
    func updateUserPhoto(imageURL: URL)
    func updateUserName()
    func updateTableView()
    func dismissCreatePlaylistPopup()
}

class ProfileVM {
    
    //MARK: - Variables
    var userName: String?
    var playlists: [UserPlaylist]?
    var userFavoriteTracks: [Track]?
    weak var delegate: ProfileVMDelegate?
    lazy var firestoreManager = FirestoreManager()
    lazy var firebaseAuthManager = FirebaseAuthManager()
    
    
    //MARK: - Helper Functions
    func getUserName() {
        firestoreManager.getUserName { [weak self] userName in
            guard let self else { return }
            self.userName = userName
            delegate?.updateUserName()
        } onError: { error in
            print(error)
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
        let storageRefernce = Storage.storage().reference()

        let imageData = imageData.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else{
            return
        }
        
        let fileRef = storageRefernce.child("Media/\(ApplicationVariables.currentUserID ?? "").jpg")
        
        fileRef.putData(imageData!, metadata: nil) { meta, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.fetchUserPhoto()
        }
    }
    
    func fetchUserPhoto() {
        let storageRef = Storage.storage().reference()
        
        let fileRef = storageRef.child("Media/\(ApplicationVariables.currentUserID ?? "").jpg")
        fileRef.downloadURL { [weak self] url, error in
            guard let self else {return}
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let url else {return}
            self.delegate?.updateUserPhoto(imageURL: url)
          
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
