//
//  PlayerViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 11.11.2023.
//

import Foundation

protocol PlayerViewModelDelegate: AnyObject {
    func updateUI(track: Track)
    func musicTimeSliderValueChanged(selectedTimeInSeconds: Float)
    func didRewind()
    func didPlay()
    func didForward()
    func sliderVolumeChanged(selectedVolume: Float)
    func volumeDownPressed()
    func volumeUpPressed()
}

final class PlayerViewModel {
    
    weak var delegate: PlayerViewModelDelegate?
    
    func updateTrackInfo(track: Track) {
        delegate?.updateUI(track: track)
    }
    
    
    func musicTimeSliderValueChanged(selectedTimeInSeconds: Float){
        print("Selected Time: \(selectedTimeInSeconds) in ViewModel")
        delegate?.musicTimeSliderValueChanged(selectedTimeInSeconds: selectedTimeInSeconds)
    }
    func rewindButtonPressed() {
        print("Rewind button pressed in ViewModel")
        delegate?.didRewind()
    }
    
    func playButtonPressed() {
        print("Play button pressed in ViewModel")
        delegate?.didPlay()
    }
    
    func fastForwardButtonPressed() {
        print("Fast forward button pressed in ViewModel")
        delegate?.didForward()
    }
    
    
    
    func sliderVolumeChanged(selectedVolume: Float) {
        print("Selected Time: \(selectedVolume) in ViewModel")
        delegate?.sliderVolumeChanged(selectedVolume: selectedVolume)
    }
    
    func volumeDownPressed() {
        print("Volume Down Pressed in ViewModel")
        delegate?.volumeDownPressed()
    }
    
    func volumeUpPressed() {
        print("Volume Up Pressed in ViewModel")
        delegate?.volumeUpPressed()
    }
    
}
