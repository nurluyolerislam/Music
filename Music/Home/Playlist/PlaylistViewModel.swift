//
//  PlaylistViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 12.11.2023.
//

import FirebaseFirestore
import FirebaseAuth

protocol PlaylistViewModelProtocol: AnyObject {
    func getRadioPlaylist(playlistURL: String)
    var tracks: [Track]? { get set }
}

protocol PlaylistViewModelDelegate: AnyObject {
    func updateUI()
}

final class PlaylistViewModel: PlaylistViewModelProtocol {
    var tracks: [Track]?
    var manager: DeezerAPIManager?
    weak var delegate: PlaylistViewModelDelegate?
    
    init(playlistURL: String, manager: DeezerAPIManager) {
        self.manager = manager
        getRadioPlaylist(playlistURL: playlistURL)
    }
    
    init(userplaylist: UserPlaylist) {
        getUserPlaylist(playlist: userplaylist)
    }
    
    func getRadioPlaylist(playlistURL: String) {
        manager?.getRadioPlaylist(playlistURL: playlistURL) { data in
            if let tracks = data?.data {
                self.tracks = tracks
            }
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
        
    }
    
    func getUserPlaylist(playlist: UserPlaylist) {
        
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("playlists")
            .document(playlist.title!)
            .collection("tracks")
            .getDocuments { [weak self] snapshot, error in
                
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let documents = snapshot?.documents else { return }
                let tracks = documents.compactMap({try? $0.data(as: Track.self)})
                self.tracks = tracks
                
                delegate?.updateUI()
            }
    }
}
