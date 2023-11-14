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
            "title" : playlistName,
            "trackCount" : 0
        ] as [String : Any]
        
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("playlists")
            .document(playlistName)
            .setData(data) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                getPlaylists()
                delegate?.createPlaylistPopupDismiss()
            }
    }
    
    func removeTrackFromFavorites(track: Track) {
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("favorites")
            .document(track.id!.description)
            .delete() { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                getFavoriteTracks()
                delegate?.updateUI()
            }
    }
    
    func removePlaylist(playlist: UserPlaylist) {
        let ref = Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("playlists")
            .document(playlist.title!)
        
        ref.collection("tracks").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            snapshot?.documents.forEach { document in
                document.reference.delete()
            }
        }
        
        ref
            .delete() { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                getPlaylists()
                delegate?.updateUI()
            }
    }
    
}
