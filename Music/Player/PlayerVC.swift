//
//  PlayerVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

class PlayerVC: UIViewController {

    lazy var playerUIView = PlayerUIView()
    var viewModel: PlayerViewModel?

    init(songModel:Track) {
        super.init(nibName: nil, bundle: nil)
        viewModel = PlayerViewModel()
        viewModel?.delegate = self
        viewModel?.updateTrackInfo(track: songModel)
        playerUIView.viewModel = viewModel
        view = playerUIView
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Configuration
    private func configureUI(songModel: Track){
        
    }

    
}


extension PlayerVC: PlayerViewModelDelegate {
 
    
    func updateUI(track: Track) {
        playerUIView.songTitle.text = track.title
        playerUIView.artistName.text = track.artist?.name
        
    }
    func musicTimeSliderValueChanged(selectedTimeInSeconds: Float) {
        print("Selected Time: \(selectedTimeInSeconds) in VC")
        let formattedTime = playerUIView.formatTime(seconds: Int(selectedTimeInSeconds))
        playerUIView.timeLabelMin.text = formattedTime
    }
    

    func didRewind() {
        // ViewModel'den gelen sonuçlara tepki olarak UI güncellemelerini yapabilirsiniz
        if 0 <= playerUIView.songSlider.value && playerUIView.songSlider.value < 10 {
            playerUIView.songSlider.value = 0
        } else {
            let newValue = playerUIView.songSlider.value - 10
            playerUIView.songSlider.value = max(0, newValue)
        }
        
        let formattedTime = playerUIView.formatTime(seconds: Int(playerUIView.songSlider.value))
        playerUIView.timeLabelMin.text = formattedTime
    }
    
    func didPlay() {
        
    }
    
    func didForward() {
        if 20 < playerUIView.songSlider.value && playerUIView.songSlider.value <= 30 {
            playerUIView.songSlider.value = 30
        } else {
            let newValue = playerUIView.songSlider.value + 10
            playerUIView.songSlider.value = min(30, newValue)
        }
        
        let formattedTime = playerUIView.formatTime(seconds: Int(playerUIView.songSlider.value))
        playerUIView.timeLabelMin.text = formattedTime
    }
    
    func sliderVolumeChanged(selectedVolume: Float) {
        print("Selected Time: \(selectedVolume) in VC")
    }
    
    func volumeDownPressed() {
        playerUIView.volumeSlider.value -= 10
    }
    
    func volumeUpPressed() {
        playerUIView.volumeSlider.value += 10
    }

}

