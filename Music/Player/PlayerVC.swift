//
//  PlayerVC.swift
//  Music
//
//  Created by Yaşar Duman & Erislam Nurluyol on 9.11.2023.
//

import UIKit
import AVFoundation
import Kingfisher

class PlayerVC: UIViewController {
    
    //MARK: - Variables
    lazy var playerUIView = PlayerUIView()
    var viewModel: PlayerViewModel?
//    var player: AVPlayer?
    var currentDuration: CMTime = .init(seconds: 0, preferredTimescale: 1)
    
    
    //MARK: - Initializers
    init(track: Track) {
        super.init(nibName: nil, bundle: nil)
        viewModel = PlayerViewModel(track: track)
        addTargets()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = playerUIView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAudio()
    }
    
    
    //MARK: - UI Configuration
    private func configureUI(){
        playerUIView.songImage.kf.setImage(with: URL(string: viewModel!.track.album!.coverXl!)!)
        playerUIView.songTitle.text = viewModel?.track.title
        playerUIView.artistName.text = viewModel?.track.artist?.name
        playerUIView.timeLabelMax.text = formatTime(seconds: 30)
    }
    
    private func addTargets() {
        playerUIView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playerUIView.songSlider.addTarget(self, action: #selector(musicTimeSliderValueChanged(_:)), for: .valueChanged)
        playerUIView.songSlider.addTarget(self, action: #selector(musicTimeSliderEndEditing(_:)), for: .touchUpInside)
        playerUIView.rewindButton.addTarget(self, action: #selector(rewindButtonPressed), for: .touchUpInside)
        playerUIView.fastForwardButton.addTarget(self, action: #selector(fastForwardButtonPressed), for: .touchUpInside)
        playerUIView.volumeDownButton.addTarget(self, action: #selector(volumeDownPressed), for: .touchUpInside)
        playerUIView.volumeUpButton.addTarget(self, action: #selector(volumeUpPressed), for: .touchUpInside)
        playerUIView.volumeSlider.addTarget(self, action: #selector(sliderVolumeChanged(_:)), for: .valueChanged)
    }
    
    
    //MARK: - Helper Functions
    func playAudio() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime, object: viewModel?.playerItem)
        
        viewModel?.player?.seek(to: currentDuration)
        viewModel?.player?.play()
        
        viewModel?.isPlaying = true
        playerUIView.playButton.setImage(UIImage(systemName: "pause.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40,
                                                           weight: .regular)),
                                         for: .normal)
        
        viewModel?.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentDuration = time
            self.playerUIView.songSlider.value = Float(time.seconds)
            self.playerUIView.timeLabelMin.text = formatTime(seconds: Int(time.seconds))
        }
    }
    
    func pauseAudio() {
        viewModel?.player?.pause()
        viewModel?.isPlaying = false
        playerUIView.playButton.setImage(UIImage(systemName: "play.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40,
                                                           weight: .regular)),
                                         for: .normal)
    }
    
    //MARK: - @Actions
    @objc func playerDidFinishPlaying(){
        viewModel?.player?.seek(to: CMTime.zero)
        pauseAudio()
    }
    
    @objc func playButtonTapped(){
        if viewModel!.isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
    @objc func musicTimeSliderValueChanged(_ sender: UISlider) {
        pauseAudio()
        playerUIView.timeLabelMin.text = formatTime(seconds: Int(sender.value))
    }
    
    @objc func musicTimeSliderEndEditing(_ sender: UISlider){
        let timeToSeek = CMTimeMakeWithSeconds(Double(sender.value), preferredTimescale: 1)
        currentDuration = timeToSeek
        playAudio()
    }
    
    @objc func rewindButtonPressed() {
        let timeToRewind = CMTimeMakeWithSeconds(5, preferredTimescale: 1)
        viewModel?.player?.seek(to: CMTimeSubtract(viewModel?.player?.currentTime() ?? CMTime.zero, timeToRewind))
    }
    
    @objc func fastForwardButtonPressed() {
        let timeToForward = CMTimeMakeWithSeconds(5, preferredTimescale: 1)
        viewModel?.player?.seek(to: CMTimeAdd(viewModel?.player?.currentTime() ?? CMTime.zero, timeToForward))
    }
    
    @objc func sliderVolumeChanged(_ sender: UISlider) {
        viewModel?.player?.volume = sender.value / 10
    }
    
    @objc func volumeDownPressed() {
        playerUIView.volumeSlider.value -= 1
        adjustVolume(delta: -0.1)
    }
    
    @objc func volumeUpPressed() {
        playerUIView.volumeSlider.value += 1
        adjustVolume(delta: 0.1)
    }
    
    func adjustVolume(delta: Float) {
        let newVolume = max(0.0, min((viewModel?.player?.volume ?? 0.0) + delta, 1.0))
        viewModel?.player?.volume = newVolume
    }
    
    // MARK: - FormatTime Function
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
}
