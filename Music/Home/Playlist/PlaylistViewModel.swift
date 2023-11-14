//
//  PlaylistViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 12.11.2023.
//

protocol PlaylistViewModelProtocol: AnyObject {
    func getRadioPlaylist(playlistURL: String)
    var tracks: [Track]? { get set }
}

protocol PlaylistViewModelDelegate: AnyObject {
    func updateUI()
}

final class PlaylistViewModel: PlaylistViewModelProtocol {
    var tracks: [Track]?
    var userPlaylist: UserPlaylist?
    var deezerAPIManager: DeezerAPIManager?
    var firestoreManager: FirestoreManager?
    weak var delegate: PlaylistViewModelDelegate?
    
    init(playlistURL: String, deezerAPIManager: DeezerAPIManager) {
        self.deezerAPIManager = deezerAPIManager
        getRadioPlaylist(playlistURL: playlistURL)
    }
    
    init(userplaylist: UserPlaylist, firestoreManager: FirestoreManager) {
        self.userPlaylist = userplaylist
        self.firestoreManager = firestoreManager
        getUserPlaylist(playlist: userplaylist)
    }
    
    func getRadioPlaylist(playlistURL: String) {
        deezerAPIManager?.getRadioPlaylist(playlistURL: playlistURL) { data in
            if let tracks = data?.data {
                self.tracks = tracks
            }
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
        
    }
    
    func getUserPlaylist(playlist: UserPlaylist) {
        firestoreManager?.getUserPlaylist(playlist: playlist) { tracks in
            self.tracks = tracks
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
    }
    
    func removeTrackFromPlaylist(track: Track) {
        if let userPlaylist = userPlaylist {
            firestoreManager?.removeTrackFromPlaylist(track: track, userPlaylist: userPlaylist) { [weak self] in
                guard let self = self else { return }
                getUserPlaylist(playlist: userPlaylist)
            } onErorr: { error in
                print(error)
            }
        }
    }
    
}
