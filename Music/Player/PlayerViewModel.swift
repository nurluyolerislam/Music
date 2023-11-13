//
//  PlayerViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 11.11.2023.
//

import AVFoundation

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

    
}
