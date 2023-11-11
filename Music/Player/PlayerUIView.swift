//
//  PlayerUIView.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

class PlayerUIView: UIView {
    
    // MARK: - Properties
    var viewModel: PlayerViewModel?
    
    //MARK: - UI Elements
    lazy var containerVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [songImage,
                                                   textVStack,
                                                   sliderVStack,
                                                   playerControlsHstack,
                                                   sliderVolumeHStack])
        stack.setCustomSpacing(35, after: textVStack)
        stack.setCustomSpacing(25, after: sliderVStack)
        stack.setCustomSpacing(25, after: playerControlsHstack)
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    lazy var songImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profileImage")
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.anchor(size: .init(heightSize: 400))
        return image
    }()
    
    lazy var textVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [songTitle,
                                                   artistName])
        stack.axis = .vertical
        return stack
    }()
    
    lazy var songTitle: UILabel = {
        let label = UILabel()
        label.text = "Song Name"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    lazy var artistName: UILabel = {
        let label = UILabel()
        label.text = "Artist Name"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var sliderVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [songSlider,
                                                   timeHStack])
        stack.axis = .vertical
        return stack
    }()
    
    lazy var songSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 30 // Maksimum değeri saniye cinsinden ayarladık
        slider.value = 0 // Başlangıç değeri
        slider.addTarget(self, action: #selector(musicTimeSliderValueChanged(_:)), for: .valueChanged)
        
        return slider
    }()
    
    lazy var timeHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeLabelMin,
                                                   timeLabelMax])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var timeLabelMin: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        return label
    }()
    
    lazy var timeLabelMax: UILabel = {
        let label = UILabel()
        label.text = "0:30"
        return label
    }()
    
    lazy var playerControlsHstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rewindButton,
                                                   playButton,
                                                   fastForwardButton])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        return stack
    }()
    
    lazy var rewindButton: UIButton = {
        let button = UIButton()
        
        if let image = UIImage(systemName: "gobackward.10")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)) {
            button.setImage(image, for: .normal)
            button.tintColor = .label
            button.addTarget(self, action: #selector(rewindButtonPressed(_:)), for: .touchUpInside)
        }
        
        return button
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        
        if let image = UIImage(systemName: "play.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)) {
            button.setImage(image, for: .normal)
            button.tintColor = .label
            button.addTarget(self, action: #selector(playButtonPressed(_:)), for: .touchUpInside)
        }
        
        return button
    }()
    
    lazy var fastForwardButton: UIButton = {
        let button = UIButton()
        
        if let image = UIImage(systemName: "goforward.10")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)) {
            button.setImage(image, for: .normal)
            button.tintColor = .label
            button.addTarget(self, action: #selector(fastForwardButtonPressed(_:)), for: .touchUpInside)
        }
        
        return button
    }()
    
    lazy var sliderVolumeHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [volumeDownButton,
                                                   volumeSlider,
                                                   volumeUpButton])
        stack.spacing = 5
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var volumeDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(volumeDownPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var volumeUpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(volumeUpPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 30
        slider.addTarget(self, action: #selector(sliderVolumeChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Configuration
    private func configureUI(){
        backgroundColor = .systemBackground
        configureVStack()
    }
    
    private func configureVStack(){
        addSubview(containerVStack)
        
        containerVStack.anchor(top: safeAreaLayoutGuide.topAnchor,
                               leading: safeAreaLayoutGuide.leadingAnchor,
                               trailing: safeAreaLayoutGuide.trailingAnchor,
                               padding: .init(top: 10, leading: 20, trailing: 20))
    }
    
    //MARK: - sliderValue @Actions
    @objc func musicTimeSliderValueChanged(_ sender: UISlider) {
        viewModel?.musicTimeSliderValueChanged(selectedTimeInSeconds: sender.value)
    }
    
    // MARK: - FormatTime Function
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    //MARK: - PlayerControls @Actions
    @objc func rewindButtonPressed(_ sender: UIButton) {
        viewModel?.rewindButtonPressed()
    }
    
    @objc func playButtonPressed(_ sender: UIButton) {
        viewModel?.playButtonPressed()
        
    }
    
    @objc func fastForwardButtonPressed(_ sender: UIButton) {
        viewModel?.fastForwardButtonPressed()
        
    }
    
    
    //MARK: - sliderVolume @Actions
    @objc func sliderVolumeChanged(_ sender: UISlider) {
        viewModel?.sliderVolumeChanged(selectedVolume: sender.value)
  
    }
    
    @objc func volumeDownPressed(_ sender: UIButton) {
        viewModel?.volumeDownPressed()

    }
    
    @objc func volumeUpPressed(_ sender: UIButton) {
        viewModel?.volumeUpPressed()
        volumeSlider.value += 10
    }
}
