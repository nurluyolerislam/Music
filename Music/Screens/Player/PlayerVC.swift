//
//  PlayerVC.swift
//  Music
//
//  Created by Yaşar Duman & Erislam Nurluyol on 9.11.2023.
//

import UIKit
import CoreMedia
import Kingfisher


final class PlayerVC: UIViewController {
    
    //MARK: - Variables
    private lazy var playerView = PlayerView()
    var viewModel: PlayerViewModel?
    
    
    //MARK: - Initializers
    init(track: Track) {
        super.init(nibName: nil, bundle: nil)
        viewModel = PlayerViewModel(track: track)
        viewModel?.playerDelegate = self
        addTargets()
        configureUI()
        viewModel?.playAudio()
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
        configureSongImage()
        configureSongTitle()
        configureArtistName()
        configureTimeLabelMax()
        configureLikeImage()
    }
    
    private func configureSongImage() {
        guard let viewModel else {return}
        guard let album = viewModel.track.album else {return}
        guard let imageURl = album.coverXl else {return}
        
        playerView.songImage.kf.setImage(with: URL(string: imageURl))
    }
    
    private func configureSongTitle() {
        playerView.songTitle.text = viewModel?.track.title
    }
    
    private func configureArtistName() {
        playerView.artistName.text = viewModel?.track.artist?.name
    }
    
    private func configureTimeLabelMax() {
        playerView.timeLabelMax.text = 30.formatTime()
    }
    
    private func configureLikeImage() {
        viewModel?.checkTrackFavorited() { [weak self] isFavorited in
            guard let self else { return }
            if isFavorited {
                playerView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                playerView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    
    //MARK: - Targets
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
    
    
    //MARK: - @Actions
    @objc private func playButtonTapped(){
        if viewModel!.isPlaying {
            viewModel?.pauseAudio()
        } else {
            viewModel?.playAudio()
        }
    }
    
    @objc private func musicTimeSliderValueChanged(_ sender: UISlider) {
        viewModel?.pauseAudio()
        playerView.timeLabelMin.text = Int(sender.value).formatTime()
    }
    
    @objc private func musicTimeSliderEndEditing(_ sender: UISlider){
        let timeToSeek = CMTimeMakeWithSeconds(Double(sender.value), preferredTimescale: 1)
        viewModel?.currentDuration = timeToSeek
        viewModel?.playAudio()
    }
    
    @objc private func rewindButtonPressed() {
        let timeToRewind = CMTimeMakeWithSeconds(5, preferredTimescale: 1)
        viewModel?.player?.seek(to: CMTimeSubtract(viewModel?.player?.currentTime() ?? CMTime.zero, timeToRewind))
    }
    
    @objc private func fastForwardButtonPressed() {
        let timeToForward = CMTimeMakeWithSeconds(5, preferredTimescale: 1)
        viewModel?.player?.seek(to: CMTimeAdd(viewModel?.player?.currentTime() ?? CMTime.zero, timeToForward))
    }
    
    @objc private func sliderVolumeChanged(_ sender: UISlider) {
        viewModel?.player?.volume = sender.value / 10
    }
    
    @objc private func volumeDownPressed() {
        playerView.volumeSlider.value -= 1
        viewModel?.adjustVolume(delta: -0.1)
    }
    
    @objc private func volumeUpPressed() {
        playerView.volumeSlider.value += 1
        viewModel?.adjustVolume(delta: 0.1)
    }
    
    @objc private func addToPlaylistButtonTapped(){
        let track = viewModel!.track
        let popup = AddToPlaylistPopupVC(tack: track)
        popup.modalPresentationStyle  = .overFullScreen
        popup.modalTransitionStyle    = .crossDissolve
        present(popup, animated: true)
    }
    
    @objc private func likeButtonTapped() {
        viewModel?.toggleLikeStatus() { [weak self] isFavorited in
            guard let self else { return }
            if isFavorited {
                playerView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                playerView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
}

extension PlayerVC: PlayerDelegate {
    var currentDuration: CMTime {
        get {
            viewModel?.currentDuration ?? CMTime.zero
        }
        set {
            playerView.songSlider.value = Float(newValue.seconds)
            playerView.timeLabelMin.text = Int(newValue.seconds).formatTime()
        }
    }
    
    func toggleButtonImage() {
        if let viewModel = viewModel {
            let isPlaying = viewModel.isPlaying
            
            playerView.playButton.setImage(UIImage(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40,
                                                               weight: .regular)),
                                                               for: .normal)
        }
    }
}
