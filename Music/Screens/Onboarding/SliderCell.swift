//
//  SliderCell.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import UIKit
import Lottie

final class SliderCell: UICollectionViewCell {
    
    //MARK: - Reuse Identifier
    static let reuseID = "SliderCell"
    
    
    //MARK: - UI Elements
    private lazy var lottieView: LottieAnimationView = {
        let lottieView = LottieAnimationView()
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFit
        return lottieView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .authButtonBackground
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    private func configureUI() {
        configureLottieView()
        configureTitleLabel()
        configureTextLabel()
    }
    
    private func configureLottieView() {
        contentView.addSubview(lottieView)
        lottieView.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor,
                          padding: UIEdgeInsets(top: 140,
                                                left: 0,
                                                bottom: 0,
                                                right: 0),
                          size: CGSize(width: .zero,
                                       height: 300))
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: lottieView.bottomAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor,
        padding: UIEdgeInsets(top: 40,
                              left: 20,
                              bottom: 0,
                              right: 20))
    }
    
    private func configureTextLabel() {
        contentView.addSubview(textLabel)
        textLabel.anchor(top: titleLabel.bottomAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor,
        padding: UIEdgeInsets(top: 30,
                              left: 20,
                              bottom: 0,
                              right: 20))
    }
    
    
    // MARK: - Animation Setup
    func animationSetup(animationName: String){
        lottieView.animation = LottieAnimation.named(animationName)
        lottieView.play()
    }
    
    
    //MARK: - Helper Functions
    func updateUI(sliderData: OnboardingItemModel) {
        contentView.backgroundColor = sliderData.color
        titleLabel.text = sliderData.title
        textLabel.text = sliderData.text
        animationSetup(animationName: sliderData.animationName)
    }
    
}
