//
//  PlayerUIView.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit
import MediaPlayer

class PlayerUIView: UIView {
    
    //MARK: - UI Elements
    lazy var containerVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            songImage,
            textAndLikeContainer,
            sliderVStack,
            playerControlsHstack,
            sliderVolumeHStack
        ])
        stack.setCustomSpacing(25, after: textAndLikeContainer)
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
    
    lazy var textAndLikeContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textVStack,
                                                   likeImage])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    
    lazy var textVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            songTitle,
            artistName
        ])
        stack.axis = .vertical
        return stack
    }()
    lazy var likeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "heart",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        image.anchor(size: .init(width: 30, height: 30))
        image.tintColor = .label
        image.isUserInteractionEnabled = true
        return image
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
        let stack = UIStackView(arrangedSubviews: [
            songSlider,
            timeHStack
        ])
        stack.axis = .vertical
        return stack
    }()
    
    lazy var songSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 30 // Maksimum değeri saniye cinsinden ayarladık
        slider.value = 0 // Başlangıç değeri
        return slider
    }()
    
    lazy var timeHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            timeLabelMin,
            timeLabelMax
        ])
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
//        label.text = "0:30"
        return label
    }()
    
    lazy var playerControlsHstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            rewindButton,
            playButton,
            fastForwardButton
        ])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        return stack
    }()
    
    lazy var rewindButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "gobackward.5")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)) {
            button.setImage(image, for: .normal)
            button.tintColor = .label
        }
        return button
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "play.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)) {
            button.setImage(image, for: .normal)
            button.tintColor = .label
        }
        return button
    }()
    
    lazy var fastForwardButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "goforward.5")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)) {
            button.setImage(image, for: .normal)
            button.tintColor = .label
        }
        return button
    }()
    
    lazy var sliderVolumeHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            volumeDownButton,
            volumeSlider,
            volumeUpButton
        ])
        stack.spacing = 5
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var volumeDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    lazy var volumeUpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 5
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
                               padding: .init(top: 10, 
                                              leading: 20,
                                              trailing: 20))
    }
    
}
