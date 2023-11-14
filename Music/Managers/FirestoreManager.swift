//
//  FirestoreManager.swift
//  Music
//
//  Created by Erislam Nurluyol on 14.11.2023.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    private let currentUserRef = Firestore.firestore()
        .collection("UsersInfo")
        .document(Auth.auth().currentUser!.uid)
    
    func getUserPlaylist(playlist: UserPlaylist, onSuccess: @escaping ([Track]?)->(Void), onError: @escaping (String)-> Void) {
        let ref = currentUserRef.collection("playlists")
            .document(playlist.title!)
            .collection("tracks")
        
        FirestoreService.shared.getDocuments(reference: ref) { (tracks: [Track]) in
            onSuccess(tracks)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func getUserPlaylists(onSuccess: @escaping ([UserPlaylist]?)->(Void), onError: @escaping (String)-> Void) {
        let ref = currentUserRef
            .collection("playlists")
        
        FirestoreService.shared.getDocuments(reference: ref) { (playlists: [UserPlaylist]) in
            onSuccess(playlists)
        } onError: { error in
            onError(error.localizedDescription)
        }
        
    }
    
    func getUserFavoriteTracks (onSuccess: @escaping ([Track]?)->(Void), onError: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("favorites")
        
        FirestoreService.shared.getDocuments(reference: ref) { (tracks: [Track]) in
            onSuccess(tracks)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func removePlaylist(playlist: UserPlaylist, onSuccess: @escaping () -> Void, onErorr: @escaping (String) -> Void) {
        let playlistRef = currentUserRef
            .collection("playlists")
            .document(playlist.title!)
        
        let tracksRef = playlistRef
            .collection("tracks")
        
        FirestoreService.shared.deleteDocument(reference: playlistRef) {
            onSuccess()
        } onError: { error in
            onErorr(error.localizedDescription)
        }
        
        FirestoreService.shared.deleteCollection(reference: tracksRef) { error in
            onErorr(error.localizedDescription)
        }
    }
    
    func removeTrackFromFavorites(track: Track, onSuccess: @escaping () -> Void, onErorr: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("favorites")
            .document(track.id!.description)
        
        FirestoreService.shared.deleteDocument(reference: ref) {
            onSuccess()
        } onError: { error in
            onErorr(error.localizedDescription)
        }
    }
    
    func createNewPlaylist(playlistName: String, onSuccess: @escaping () -> Void, onErorr: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("playlists")
            .document(playlistName)
        
        let data = [
            "title" : playlistName,
            "trackCount" : 0
        ] as [String : Any]
        
        FirestoreService.shared.setData(reference: ref, data: data) {
            onSuccess()
        } onError: { error in
            onErorr(error.localizedDescription)
        }
    }
    
    func getRecentSearches(onSuccess: @escaping ([String]?)->(Void), onError: @escaping (String) -> Void) {
        let ref = currentUserRef
        
        FirestoreService.shared.getField(reference: ref, fieldName: "recentSearches") { (recentSearches: [String]) in
            onSuccess(recentSearches)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func checkTrackFavorited(track: Track, onSuccess: @escaping (Bool) -> Void, onError: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("favorites")
            .document(track.id!.description)
        
        FirestoreService.shared.checkDocumentExists(reference: ref) { exists in
            onSuccess(exists)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func updateRecentSearches(searchText: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let ref = currentUserRef
        
        getRecentSearches { recentSearches in
            if let recentSearches = recentSearches {
                if recentSearches.count == 10 {
                    let dataThatWillRemove = ["recentSearches" : FieldValue.arrayRemove([recentSearches.first])]
                    FirestoreService.shared.updateData(reference: ref, data: dataThatWillRemove) {
                    } onError: { error in
                        onError(error.localizedDescription)
                    }
                }
                let dataThatWillAppend = ["recentSearches" : FieldValue.arrayUnion([searchText])]
                FirestoreService.shared.updateData(reference: ref, data: dataThatWillAppend) {
                    onSuccess()
                } onError: { error in
                    onError(error.localizedDescription)
                }
            }
        } onError: { error in
            onError(error)
        }
    }
    
    func addTrackToPlaylist(track: Track, playlistID: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let playlistRef = currentUserRef
            .collection("playlists")
            .document(playlistID)
        
        let ref = playlistRef
            .collection("tracks")
            .document(track.id!.description)
        
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
        
        FirestoreService.shared.checkDocumentExists(reference: ref) { exists in
            if exists {
                return
            } else {
                FirestoreService.shared.setData(reference: ref, data: data) {
                    FirestoreService.shared.updateData(reference: playlistRef, data: ["trackCount" : FieldValue.increment(1.0)]) {
                        onSuccess()
                    } onError: { error in
                        onError(error.localizedDescription)
                    }
                } onError: { error in
                    onError(error.localizedDescription)
                }
            }
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func removeTrackFromPlaylist(track: Track, userPlaylist: UserPlaylist, onSuccess: @escaping () -> Void, onErorr: @escaping (String) -> Void) {
        let playlistRef = currentUserRef
            .collection("playlists")
            .document(userPlaylist.title!)
        
        let trackRef = playlistRef
            .collection("tracks")
            .document(track.id!.description)
        
        FirestoreService.shared.deleteDocument(reference: trackRef) {
            FirestoreService.shared.updateData(reference: playlistRef, data: ["trackCount" : FieldValue.increment(-1.0)]) {
                onSuccess()
            } onError: { error in
                onErorr(error.localizedDescription)
            }
        } onError: { error in
            onErorr(error.localizedDescription)
        }
    }
    
    func addTrackToFavorites(track: Track, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let trackRef = currentUserRef
            .collection("favorites")
            .document(track.id!.description)
        
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
        
        FirestoreService.shared.setData(reference: trackRef, data: data) {
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    
}

