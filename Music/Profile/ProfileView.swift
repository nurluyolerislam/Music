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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        return stackView
    }()
    
     lazy var userImage : UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(named: "profileImage")
        userImage.contentMode = .scaleAspectFit
        userImage.layer.cornerRadius = 15
        userImage.clipsToBounds = true
        return userImage
    }()
    
     lazy var userName: UILabel = {
        let userName = UILabel()
        userName.text = "Yaşar Duman"
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
    }
    
    private func configureHeaderStackView(){
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(userImage)
        headerStackView.addArrangedSubview(userName)
        headerStackView.addArrangedSubview(editButton)
        
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
                         padding: .init(top: 20, leading: 20, trailing: 20))
    }
}
