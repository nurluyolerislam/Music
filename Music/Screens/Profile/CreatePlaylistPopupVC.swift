//
//  CreatePlaylistPopupVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit

final class CreatePlaylistPopupVC: UIViewController {
    
    //MARK: - UI Elements
    lazy var containerView  = AlertContainerView()
    
    private lazy var titleLabel: TitleLabel = {
        let label = TitleLabel(textAlignment: .center, fontSize: 20)
        label.text = "Create a New Playlist"
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Playlist name..."
        return textField
    }()
    
    lazy var createButton: MusicButton = {
        let button = MusicButton(bgColor: .systemPink, color: .systemPink, title: "Create", systemImageName: "checkmark.circle")
        return button
    }()
    
    private lazy var cancelButton: MusicButton = {
        let button = MusicButton(bgColor: .systemPink, color: .systemPink, title: "Cancel", systemImageName: "x.circle")
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            createButton,
            cancelButton
        ])
        stackView.spacing = 10
        return stackView
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureUI()
        
    }
    
    //MARK: - Configuration Methods
    private func configureUI() {
        configureContainerView()
        configureTitleLabel()
        configureTextView()
        configureButtonsStackView()
    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.centerInSuperview()
        containerView.anchor(size: .init(width: 280, height: 220))
    }
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: containerView.topAnchor,
                          leading: containerView.leadingAnchor,
                          trailing: containerView.trailingAnchor,
                          padding: .init(top: 20,
                                         leading: 20,
                                         trailing: 20),
                          size: .init(heightSize: 28))
    }
    
    private func configureTextView() {
        containerView.addSubview(textField)
        textField.centerYInSuperview()
        textField.anchor(leading: containerView.leadingAnchor,
                        trailing: containerView.trailingAnchor,
                        padding: .init(leading: 20,
                                       trailing: 20))
    }
    
    private func configureButtonsStackView() {
        containerView.addSubview(buttonsStackView)
        buttonsStackView.anchor(leading: containerView.leadingAnchor,
                                bottom: containerView.bottomAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: .init(leading: 20,
                                               bottom: 20,
                                              trailing: 20))
    }
    
    
    // MARK: - Actions
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
}
