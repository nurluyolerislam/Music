//
//  ProfileVM.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

protocol ProfileVMDelegate: AnyObject {
    func updateUI()
    func dismissCreatePlaylistPopup()
}

class ProfileVM {
    var playlists: [UserPlaylist]?
    var userFavoriteTracks: [Track]?
    weak var delegate: ProfileVMDelegate?
    lazy var firestoreManager = FirestoreManager()
    
    
    deinit{
        print("------->>>>>> DEBUG: profile vm de init")
    }
    
    
    func getUserPlaylists () {
        firestoreManager.getUserPlaylists { [weak self] playlists in
            guard let self = self else { return }
            self.playlists = playlists
            delegate?.updateUI()
        } onError: { error in
            print(error)
        }
    }
    
    func getUserFavoriteTracks () {
        firestoreManager.getUserFavoriteTracks { [weak self] tracks in
            guard let self = self else { return }
            self.userFavoriteTracks = tracks
            delegate?.updateUI()
        } onError: { error in
            print(error)
        }
    }
    
    func createNewPlaylist(playlistName: String) {
        firestoreManager.createNewPlaylist(playlistName: playlistName) { [weak self] in
            guard let self = self else { return }
            getUserPlaylists()
            delegate?.dismissCreatePlaylistPopup()
        } onErorr: { error in
            print(error)
        }
    }
    
    func removeTrackFromFavorites(track: Track) {
        firestoreManager.removeTrackFromFavorites(track: track) { [weak self] in
            guard let self = self else { return }
            getUserFavoriteTracks()
            delegate?.updateUI()
        } onErorr: { error in
            print(error)
        }
    }
    
    func removePlaylist(playlist: UserPlaylist) {
        firestoreManager.removePlaylist(playlist: playlist) { [weak self] in
            guard let self = self else { return }
            self.getUserPlaylists()
            self.delegate?.updateUI()
        } onErorr: { error in
            print(error)
        }
    }
    
    func logout(completion: @escaping () -> Void ) {
        firestoreManager.logout {
          completion()
        } onError: { error in
            print(error)
        }

    }
}
