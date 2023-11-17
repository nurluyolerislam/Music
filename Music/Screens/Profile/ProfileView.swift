//
//  ProfileView.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

final class ProfileView : UIView{
    
    //MARK: - UI Elements
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userImage,
                                                       userName,
                                                       buttonStack])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var userImage : UIImageView = {
        let userImage = UIImageView()
        let blankProfileImage = UIImage(systemName: "person.crop.square")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        userImage.image = blankProfileImage
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius = 15
        userImage.clipsToBounds = true
        return userImage
    }()
    
    lazy var userName: UILabel = {
        let userName = UILabel()
        userName.text = " "
        userName.font = UIFont.systemFont(ofSize: 20)
        userName.textColor = .label
        return userName
    }()
    
    lazy var editButton: UIButton = {
        let editButton = UIButton(configuration: .bordered())
        editButton.configuration?.cornerStyle = .capsule
        editButton.setTitle("Edit", for: .normal)
        editButton.tintColor = .label
        return editButton
    }()
    
    lazy var logoutButton: UIButton = {
        let editButton = UIButton(configuration: .tinted())
        editButton.configuration?.cornerStyle = .capsule
        editButton.setTitle("Logout", for: .normal)
        editButton.configuration?.baseBackgroundColor = .systemRed
        editButton.configuration?.baseForegroundColor = .systemRed
        return editButton
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editButton,
                                                   logoutButton])
        stack.spacing = 5
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var segenmtedControl : UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "Playlists", at: 0, animated: true)
        segment.insertSegment(withTitle: "Favorites", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ProfilePlayListTableViewCell.self, forCellReuseIdentifier: ProfilePlayListTableViewCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var createPlaylistButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.configuration?.cornerStyle = .capsule
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    lazy var createPlaylistPopup: CreatePlaylistPopupVC = {
        let popup = CreatePlaylistPopupVC()
        popup.modalPresentationStyle  = .overFullScreen
        popup.modalTransitionStyle    = .crossDissolve
        return popup
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.anchor(size: .init(width: 180, height: 180))
        editButton.anchor(size: .init(width: 120, height: 45))
    }
    
    //MARK: - UI Configuration
    private func configureUI(){
        backgroundColor = .systemBackground
        configureHeaderStackView()
        configureSegenmtedControl()
        configurePlaylistTableView()
        configureCreatePlaylistButton()
        
        
    }
    
    
    private func configureHeaderStackView(){
        addSubview(headerStackView)
        
        headerStackView.anchor(top: safeAreaLayoutGuide.topAnchor,
                               leading: leadingAnchor,
                               trailing: trailingAnchor)
    }
    
    private func configureSegenmtedControl(){
        addSubview(segenmtedControl)
        segenmtedControl.anchor(top: headerStackView.bottomAnchor,
                                leading: safeAreaLayoutGuide.leadingAnchor,
                                trailing: safeAreaLayoutGuide.trailingAnchor,
                                padding: .init(top: 20))
    }
    
    private func configurePlaylistTableView(){
        addSubview(tableView)
        tableView.anchor(top: segenmtedControl.bottomAnchor,
                         leading: segenmtedControl.leadingAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor,
                         trailing: safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 20,
                                        leading: 20,
                                        trailing: 20))
    }
    
    private func configureCreatePlaylistButton() {
        addSubview(createPlaylistButton)
        createPlaylistButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor,
                                    trailing: safeAreaLayoutGuide.trailingAnchor,
                                    padding: .init(bottom: 20,
                                                   trailing: 20),
                                    size: .init(width: 30, height: 30))
    }
}
