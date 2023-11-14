//
//  AddToPlaylistPopupVM.swift
//  Music
//
//  Created by Erislam Nurluyol on 14.11.2023.
//

protocol AddToPlaylistPopupVMDelegate: AnyObject {
    func updateUI()
    func popupDismiss()
}

class AddToPlaylistPopupVM {
    var playlists: [UserPlaylist]?
    weak var delegate: AddToPlaylistPopupVMDelegate?
    lazy var firestoreManager = FirestoreManager()
    
    init() {
        getUserPlaylists()
    }
    
    func getUserPlaylists() {
        firestoreManager.getUserPlaylists { [weak self] playlists in
            guard let self = self else { return }
            self.playlists = playlists
            delegate?.updateUI()
        } onError: { error in
            print(error)
        }
    }
    
    func addTrackToPlaylist(track: Track, playlistID: String) {
        firestoreManager.addTrackToPlaylist(track: track, playlistID: playlistID) { [weak self] in
            guard let self = self else { return }
            delegate?.popupDismiss()
        } onError: { error in
            print(error)
        }

    }
    
}
