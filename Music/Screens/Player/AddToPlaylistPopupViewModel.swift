//
//  AddToPlaylistPopupViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 14.11.2023.
//

protocol AddToPlaylistPopupViewModelDelegate: AnyObject {
    func updateUI()
    func popupDismiss()
}

final class AddToPlaylistPopupViewModel {
    var playlists: [UserPlaylist]?
    weak var delegate: AddToPlaylistPopupViewModelDelegate?
    lazy var firestoreManager = FirestoreManager()
    
    init() {
        getUserPlaylists()
    }
    
    func getUserPlaylists() {
        firestoreManager.getUserPlaylists { [weak self] playlists in
            guard let self else { return }
            self.playlists = playlists
            delegate?.updateUI()
        } onError: { error in
            print(error)
        }
    }
    
    func addTrackToPlaylist(track: Track, playlistID: String) {
        firestoreManager.addTrackToPlaylist(track: track, playlistID: playlistID) { [weak self] in
            guard let self else { return }
            delegate?.popupDismiss()
        } onError: { error in
            print(error)
        }
    }
    
}
