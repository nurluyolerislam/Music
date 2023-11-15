//
//  ProfileVM.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

protocol ProfileVMDelegate: AnyObject {
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
    
    func logout(completion: @escaping () -> Void ) {
        firebaseAuthManager.signOut {
            completion()
        } onError: { error in
            print(error)
        }
    }
    
}
