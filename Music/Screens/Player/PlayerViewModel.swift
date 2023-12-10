//
//  PlayerViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 11.11.2023.
//

import AVFoundation

protocol PlayerViewModelDelegate: AnyObject {
    func updateFavorites()
}

protocol PlayerDelegate: AnyObject {
    var currentDuration: CMTime { get set }
    func toggleButtonImage()
}

final class PlayerViewModel {
    
    //MARK: - Variables
    let track: Track
    var isPlaying = false
    let player: AVPlayer?
    let playerItem: AVPlayerItem?
    var currentDuration: CMTime = .init(seconds: 0, preferredTimescale: 1)
    private let firestoreManager: FirestoreManagerProtocol
    weak var delegate: PlayerViewModelDelegate?
    weak var playerDelegate: PlayerDelegate?
    
    //MARK: - Initializers
    init(track: Track, firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared) {
        self.track = track
        self.firestoreManager = firestoreManager
        
        if let previewURL = track.preview {
            if let url = URL(string: previewURL) {
                self.playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
                self.player?.volume = 0.5
            } else {
                print("DEBUG: Track's preview url is not valid type")
                self.playerItem = nil
                self.player = nil
            }
        } else {
            print("DEBUG: Track's preview url did not found")
            self.playerItem = nil
            self.player = nil
        }
    }
    
    
    //MARK: - Helper Functions
    func toggleLikeStatus(completion: @escaping (Bool) -> Void) {
        checkTrackFavorited { [weak self] isFavorited in
            guard let self else { return }
            if isFavorited {
                removeTrackFromFavorites { [weak self] in
                    guard let self else { return }
                    completion(false)
                    delegate?.updateFavorites()
                }
            } else {
                addTrackToFavorites { [weak self] in
                    guard let self else { return }
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
        } onError: { error in
            print(error)
        }
    }
    
    func checkTrackFavorited(completion: @escaping (Bool) -> Void) {
        firestoreManager.checkTrackFavorited(track: track) { exists in
            completion(exists)
        } onError: { error in
            print(error)
        }
    }
    
    func playAudio() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        player?.seek(to: currentDuration)
        player?.play()
        isPlaying = true
        playerDelegate?.toggleButtonImage()
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
                                        queue: .main) { [weak self] time in
            guard let self else { return }
            currentDuration = time
            playerDelegate?.currentDuration = time
        }
    }
    
    func pauseAudio() {
        player?.pause()
        isPlaying = false
        playerDelegate?.toggleButtonImage()
    }
    
    func adjustVolume(delta: Float) {
        let newVolume = max(0.0, min((player?.volume ?? 0.0) + delta, 1.0))
        player?.volume = newVolume
    }
    
    //MARK: - @Actions
    @objc func playerDidFinishPlaying(){
        player?.seek(to: CMTime.zero)
        pauseAudio()
    }
    
}
