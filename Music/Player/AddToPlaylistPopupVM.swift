//
//  AddToPlaylistPopupVM.swift
//  Music
//
//  Created by Erislam Nurluyol on 14.11.2023.
//

import FirebaseFirestore
import FirebaseAuth

protocol AddToPlaylistPopupVMDelegate: AnyObject {
    func updateUI()
    func popupDismiss()
}

class AddToPlaylistPopupVM {
    var playlists: [UserPlaylist] = []
    weak var delegate: AddToPlaylistPopupVMDelegate?
    
    init() {
        getPlaylists()
    }
    
    func getPlaylists() {
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
    
    func addTrackToPlaylist(track: Track, playlistID: String) {
        let playlistRef = Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("playlists")
            .document(playlistID)
        
        let data = [
            "id" : track.id!,
            "title" : track.title!,
            "preview" : track.preview!,
            "artist" : [
                "name" : track.artist!.name
            ],
            "album" : [
                "title" : track.album!.title!,
                "cover_xl" : track.album!.coverXl!
            ]
        ] as [String : Any]
        
        playlistRef
            .collection("tracks")
            .document(track.id!.description)
            .getDocument(){ snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                if snapshot.exists {
                    return
                } else {
                    playlistRef
                        .collection("tracks")
                        .document(track.id!.description)
                        .setData(data) { [weak self] error in
                            guard let self = self else { return }
                            
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            
                            playlistRef.updateData(["trackCount" : FieldValue.increment(1.0)])
                            
                            delegate?.popupDismiss()
                        }
                }
            }
            
    }
}
