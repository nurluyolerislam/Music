//
//  FirestoreManager.swift
//  Music
//
//  Created by Erislam Nurluyol on 14.11.2023.
//

import FirebaseFirestore

protocol FirestoreManagerProtocol {
    func getUserName(onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void)
    
    func getUserPlaylist(playlist: UserPlaylist, onSuccess: @escaping ([Track]?)->(Void), onError: @escaping (String)-> Void)
    
    func getUserPlaylists(onSuccess: @escaping ([UserPlaylist]?)->(Void), onError: @escaping (String)-> Void)
    
    func getUserFavoriteTracks (onSuccess: @escaping ([Track]?)->(Void), onError: @escaping (String) -> Void)
    
    func removePlaylist(playlist: UserPlaylist, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    
    func removeTrackFromFavorites(track: Track, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    
    func createNewPlaylist(playlistName: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    
    func getRecentSearches(onSuccess: @escaping ([String]?)->(Void), onError: @escaping (String) -> Void)
    
    func checkTrackFavorited(track: Track, onSuccess: @escaping (Bool) -> Void, onError: @escaping (String) -> Void)
    
    func updateRecentSearches(searchText: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    
    func clearRecentSearches(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    
    func addTrackToPlaylist(track: Track, playlistID: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    
    func removeTrackFromPlaylist(track: Track, userPlaylist: UserPlaylist, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    
    func addTrackToFavorites(track: Track, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
}

final class FirestoreManager {
    private let currentUserRef = Firestore.firestore()
        .collection("UsersInfo")
        .document(ApplicationVariables.currentUserID ?? "")
    
    private let service: FirestoreServiceProtocol
    
    static let shared = FirestoreManager()
    
    private init(service: FirestoreServiceProtocol = FirestoreService.shared) { self.service = service}
    
}

extension FirestoreManager: FirestoreManagerProtocol {
    func getUserName(onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        service.getField(reference: currentUserRef, fieldName: "userName") { (userName: String) in
            onSuccess(userName)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func getUserPlaylist(playlist: UserPlaylist, onSuccess: @escaping ([Track]?)->(Void), onError: @escaping (String)-> Void) {
        let ref = currentUserRef.collection("playlists")
            .document(playlist.title!)
            .collection("tracks")
        
        service.getDocuments(reference: ref) { (tracks: [Track]) in
            onSuccess(tracks)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func getUserPlaylists(onSuccess: @escaping ([UserPlaylist]?)->(Void), onError: @escaping (String)-> Void) {
        let ref = currentUserRef
            .collection("playlists")
        
        service.getDocuments(reference: ref) { (playlists: [UserPlaylist]) in
            onSuccess(playlists)
        } onError: { error in
            onError(error.localizedDescription)
        }
        
    }
    
    func getUserFavoriteTracks (onSuccess: @escaping ([Track]?)->(Void), onError: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("favorites")
        
        service.getDocuments(reference: ref) { (tracks: [Track]) in
            onSuccess(tracks)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func removePlaylist(playlist: UserPlaylist, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let playlistRef = currentUserRef
            .collection("playlists")
            .document(playlist.title!)
        
        let tracksRef = playlistRef
            .collection("tracks")
        
        service.deleteDocument(reference: playlistRef) {
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
        }
        
        service.deleteCollection(reference: tracksRef, onSuccess: nil) { error in
            onError(error.localizedDescription)
        }
    }
    
    func removeTrackFromFavorites(track: Track, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("favorites")
            .document(track.id!.description)
        
        service.deleteDocument(reference: ref) {
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func createNewPlaylist(playlistName: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("playlists")
            .document(playlistName)
        
        let data = [
            "title" : playlistName,
            "trackCount" : 0
        ] as [String : Any]
        
        service.setData(reference: ref, data: data) {
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func getRecentSearches(onSuccess: @escaping ([String]?)->(Void), onError: @escaping (String) -> Void) {
        let ref = currentUserRef
        
        service.getField(reference: ref, fieldName: "recentSearches") { (recentSearches: [String]) in
            onSuccess(recentSearches.reversed())
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func checkTrackFavorited(track: Track, onSuccess: @escaping (Bool) -> Void, onError: @escaping (String) -> Void) {
        let ref = currentUserRef
            .collection("favorites")
            .document(track.id!.description)
        
        service.checkDocumentExists(reference: ref) { exists in
            onSuccess(exists)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func updateRecentSearches(searchText: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let ref = currentUserRef
        
        getRecentSearches { recentSearches in
            if let recentSearches = recentSearches {
                if recentSearches.count == 10 && !recentSearches.contains(searchText) {
                    let dataThatWillRemove = ["recentSearches" : FieldValue.arrayRemove([recentSearches.first as Any])]
                    self.service.updateData(reference: ref, data: dataThatWillRemove) {
                    } onError: { error in
                        onError(error.localizedDescription)
                    }
                }
                let dataThatWillAppend = ["recentSearches" : FieldValue.arrayUnion([searchText])]
                self.service.updateData(reference: ref, data: dataThatWillAppend) {
                    onSuccess()
                } onError: { error in
                    onError(error.localizedDescription)
                }
            }
        } onError: { error in
            onError(error)
        }
    }
    
    func clearRecentSearches(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let ref = currentUserRef
        
        service.updateData(reference: ref, data: ["recentSearches" : []]) {
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
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
        
        service.checkDocumentExists(reference: ref) { exists in
            if exists {
                return
            } else {
                self.service.setData(reference: ref, data: data) {
                    self.service.updateData(reference: playlistRef, data: ["trackCount" : FieldValue.increment(1.0)]) {
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
    
    func removeTrackFromPlaylist(track: Track, userPlaylist: UserPlaylist, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let playlistRef = currentUserRef
            .collection("playlists")
            .document(userPlaylist.title!)
        
        let trackRef = playlistRef
            .collection("tracks")
            .document(track.id!.description)
        
        service.deleteDocument(reference: trackRef) {
            self.service.updateData(reference: playlistRef, data: ["trackCount" : FieldValue.increment(-1.0)]) {
                onSuccess()
            } onError: { error in
                onError(error.localizedDescription)
            }
        } onError: { error in
            onError(error.localizedDescription)
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
        
        service.setData(reference: trackRef, data: data) {
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
}
