//
//  PlayerViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 11.11.2023.
//

import AVFoundation

protocol PlayerVMDelegate: AnyObject {
    func updateFavorites()
}

final class PlayerViewModel {
    
    //MARK: - Variables
    let track: Track
    var isPlaying = false
    let player: AVPlayer?
    let playerItem: AVPlayerItem?
    let firestoreManager = FirestoreManager()
    weak var delegate: PlayerVMDelegate?
    
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
    
    func toggleLikeStatus(completion: @escaping (Bool) -> Void) {
        checkTrackFavorited { [weak self] isFavorited in
            guard let self = self else { return }
            if isFavorited {
                removeTrackFromFavorites { [weak self] in
                    guard let self = self else { return }
                    completion(false)
                    delegate?.updateFavorites()
                }
            } else {
                addTrackToFavorites { [weak self] in
                    guard let self = self else { return }
                    completion(true)
                    delegate?.updateFavorites()
                }
            }
        }
    }
    
    func addTrackToFavorites(completion: @escaping () -> Void) {
        firestoreManager.addTrackToFavorites(track: track) {
            completion()
        } onError: { error in
            print(error)
        }
    }
    
    func removeTrackFromFavorites(completion: @escaping () -> Void) {
        firestoreManager.removeTrackFromFavorites(track: track) {
            completion()
        } onErorr: { error in
            print(error)
        }
    }
    
    func checkTrackFavorited(completion: @escaping (Bool) -> Void) {
        firestoreManager.checkTrackFavorited(track: track) { [weak self] exists in
            guard let self = self else { return }
            completion(exists)
        } onError: { error in
            print(error)
        }
    }
    
}
