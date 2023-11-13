//
//  PlayerViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 11.11.2023.
//

import AVFoundation
import FirebaseFirestore
import FirebaseAuth

final class PlayerViewModel {
    
    //MARK: - Variables
    let track: Track
    var isPlaying = false
    let player: AVPlayer?
    let playerItem: AVPlayerItem?
    
    //MARK: - Initializers
    init(track: Track) {
        self.track = track
        
        if let previewURL = track.preview {
            self.playerItem = AVPlayerItem(url: URL(string: previewURL)!)
            self.player = AVPlayer(playerItem: playerItem)
            self.player?.volume = 0.5
        } else {
            print("DEBUG: Track's preview url did not found")
            self.playerItem = nil
            self.player = nil
        }
    }
    
    func addTrackToFavorites(completion: @escaping (Bool) -> Void) {
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
        
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("favorites")
            .document(track.id!.description)
            .setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self.isFavorited { bool in
                    completion(bool)
                }
            }
    }
    
    func removeTrackFromFavorites(completion: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("favorites")
            .document(track.id!.description)
            .delete() { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self.isFavorited { bool in
                    completion(bool)
                }
            }
    }
    
    func isFavorited(completion: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .collection("favorites")
            .document(track.id!.description)
            .getDocument { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let snapshot = snapshot {
                    completion(snapshot.exists)
                }
            }
    }

    
}
