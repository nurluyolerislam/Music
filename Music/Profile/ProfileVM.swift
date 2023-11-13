//
//  ProfileVM.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import FirebaseFirestore
import FirebaseAuth

protocol ProfileVMDelegate: AnyObject {
    func updateUI()
    func createPlaylistPopupDismiss()
}

class ProfileVM {
    var playlists: [UserPlaylist] = []
    var favoriteTracks: [Track] = []
    weak var delegate: ProfileVMDelegate?
    
    init() {
        getPlaylists()
    }
    
    func getPlaylists () {
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("playlists")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let documents = snapshot?.documents else { return }
                let playlists = documents.compactMap({try? $0.data(as: UserPlaylist.self)})
                self.playlists = playlists
                delegate?.updateUI()
            }
    }
    
    func getFavoriteTracks () {
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("favorites")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let documents = snapshot?.documents else { return }
                let tracks = documents.compactMap({try? $0.data(as: Track.self)})
                self.favoriteTracks = tracks
                delegate?.updateUI()
            }
    }
    
    func createNewPlaylist(playlistName: String) {
        let data = [
            "title" : playlistName
        ] as [String : Any]
        
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("playlists")
            .addDocument(data: data) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                getPlaylists()
                delegate?.createPlaylistPopupDismiss()
            }
    }
}
