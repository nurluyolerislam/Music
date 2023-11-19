//
//  AddToPlaylistPopupVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 14.11.2023.
//

import UIKit

final class AddToPlaylistPopupVC: UIViewController {
    
    // MARK: - Properties
    lazy var viewModel = AddToPlaylistPopupViewModel()
    lazy var containerView  = AlertContainerView()
    var track: Track?
    
    //MARK: - UI Elements
    private lazy var titleLabel: TitleLabel = {
        let label = TitleLabel(textAlignment: .center, fontSize: 20)
        label.text = "Choose Playlist"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var cancelButton: MusicButton = {
        let button = MusicButton(bgColor: .systemPink, color: .systemPink, title: "Cancel", systemImageName: "x.circle")
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    init(tack: Track) {
        self.track = tack
        super.init(nibName: nil, bundle: nil)
        tableView.register(ProfilePlayListTableViewCell.self, forCellReuseIdentifier: ProfilePlayListTableViewCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserPlaylists()
    }
    
    
    //MARK: - Configuration Methods
    private func configureUI() {
        configureContainerView()
        configureTitleLabel()
        configureCancelButton()
        configureTableView()
    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.centerInSuperview()
        containerView.anchor(size: .init(width: 280, height: 320))
    }
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: containerView.topAnchor,
                          leading: containerView.leadingAnchor,
                          trailing: containerView.trailingAnchor,
                          padding: .init(top: 10,
                                         leading: 10,
                                         trailing: 10),
                          size: .init(heightSize: 28))
    }
    
    private func configureCancelButton() {
        containerView.addSubview(cancelButton)
        cancelButton.anchor(leading: containerView.leadingAnchor,
                            bottom: containerView.bottomAnchor,
                            trailing: containerView.trailingAnchor,
                            padding: .init(leading: 10,
                                           bottom: 10,
                                           trailing: 10))
    }
    
    private func configureTableView() {
        containerView.addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor,
                         leading: containerView.leadingAnchor,
                         bottom: cancelButton.topAnchor,
                         trailing: containerView.trailingAnchor,
                         padding: .init(leading: 10,
                                        bottom: 10,
                                        trailing: 10))
    }
    
    
    // MARK: - Actions
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension AddToPlaylistPopupVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let playlists = viewModel.playlists {
            return playlists.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePlayListTableViewCell.reuseID) as! ProfilePlayListTableViewCell
        
        if let userPlaylists = viewModel.playlists {
            let userPlaylist = userPlaylists[indexPath.row]
            cell.updateUI(userPlaylist: userPlaylist)
        }
        return cell
    }
}

extension AddToPlaylistPopupVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let playlists = viewModel.playlists {
            let playlist = playlists[indexPath.row]
            
            if let title = playlist.title {
                viewModel.addTrackToPlaylist(track: track!, playlistID: title)
            }
        }
        
    }
}

extension AddToPlaylistPopupVC: AddToPlaylistPopupViewModelDelegate {
    func updateUI() {
        tableView.reloadData()
    }
    
    func popupDismiss() {
        dismissVC()
    }
}
