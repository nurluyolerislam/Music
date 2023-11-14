//
//  PlayerVC.swift
//  Music
//
//  Created by Yaşar Duman & Erislam Nurluyol on 9.11.2023.
//

import UIKit
import CoreMedia.CMTime
import Kingfisher


class PlayerVC: UIViewController {
    
    //MARK: - Variables
    lazy var playerView = PlayerView()
    var viewModel: PlayerViewModel?
    var currentDuration: CMTime = .init(seconds: 0, preferredTimescale: 1)
    
    
    //MARK: - Initializers
    init(track: Track) {
        super.init(nibName: nil, bundle: nil)
        viewModel = PlayerViewModel(track: track)
        addTargets()
        configureUI()
        playAudio()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = playerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: - UI Configuration
    private func configureUI(){
        playerView.songImage.kf.setImage(with: URL(string: viewModel!.track.album!.coverXl!)!)
        playerView.songTitle.text = viewModel?.track.title
        playerView.artistName.text = viewModel?.track.artist?.name
        playerView.timeLabelMax.text = formatTime(seconds: 30)
        
        configureLikeImage()
    }
    
    private func configureLikeImage() {
        viewModel?.isFavorited() { [weak self] bool in
            guard let self = self else { return }
            if bool {
                playerView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                playerView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    private func addTargets() {
        playerView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playerView.songSlider.addTarget(self, action: #selector(musicTimeSliderValueChanged(_:)), for: .valueChanged)
        playerView.songSlider.addTarget(self, action: #selector(musicTimeSliderEndEditing(_:)), for: .touchUpInside)
        playerView.rewindButton.addTarget(self, action: #selector(rewindButtonPressed), for: .touchUpInside)
        playerView.fastForwardButton.addTarget(self, action: #selector(fastForwardButtonPressed), for: .touchUpInside)
        playerView.volumeDownButton.addTarget(self, action: #selector(volumeDownPressed), for: .touchUpInside)
        playerView.volumeUpButton.addTarget(self, action: #selector(volumeUpPressed), for: .touchUpInside)
        playerView.volumeSlider.addTarget(self, action: #selector(sliderVolumeChanged(_:)), for: .valueChanged)
        
        playerView.addToPlaylistButton.addTarget(self, action: #selector(addToPlaylistButtonTapped), for: .touchUpInside)
        
        playerView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - Helper Functions
    func playAudio() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime, object: viewModel?.playerItem)
        
        viewModel?.player?.seek(to: currentDuration)
        viewModel?.player?.play()
        
        viewModel?.isPlaying = true
        playerView.playButton.setImage(UIImage(systemName: "pause.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40,
                                                           weight: .regular)),
                                         for: .normal)
        
        viewModel?.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentDuration = time
            self.playerView.songSlider.value = Float(time.seconds)
            self.playerView.timeLabelMin.text = formatTime(seconds: Int(time.seconds))
        }
    }
    
    func pauseAudio() {
        viewModel?.player?.pause()
        viewModel?.isPlaying = false
        playerView.playButton.setImage(UIImage(systemName: "play.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40,
                                                           weight: .regular)),
                                         for: .normal)
    }
    
    func adjustVolume(delta: Float) {
        let newVolume = max(0.0, min((viewModel?.player?.volume ?? 0.0) + delta, 1.0))
        viewModel?.player?.volume = newVolume
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
        playerView.timeLabelMin.text = formatTime(seconds: Int(sender.value))
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
        playerView.volumeSlider.value -= 1
        adjustVolume(delta: -0.1)
    }
    
    @objc func volumeUpPressed() {
        playerView.volumeSlider.value += 1
        adjustVolume(delta: 0.1)
    }
    
    @objc func addToPlaylistButtonTapped(){
        let track = viewModel!.track
        
        let popup = AddToPlaylistPopupVC(tackk: track)
        popup.modalPresentationStyle  = .overFullScreen
        popup.modalTransitionStyle    = .crossDissolve
        print("------->>>>>> DEBUG: add playlist ")
        present(popup, animated: true)
    }
    
    @objc func likeButtonTapped() {
        viewModel?.isFavorited() { [weak self] bool in
            guard let self = self else { return }
            if bool {
                viewModel?.removeTrackFromFavorites() { [weak self] bool in
                    guard let self = self else { return }
                    playerView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            } else {
                viewModel?.addTrackToFavorites() { [weak self] bool in
                    guard let self = self else { return }
                    playerView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            }
        }
    }
    
  
    
    
    
    // MARK: - FormatTime Function
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
}
