//
//  PlaylistVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 12.11.2023.
//

import UIKit

final class PlaylistVC: UIViewController {
    
    //MARK: - Variables
    let playlistView = PlaylistView()
    let viewModel: PlaylistViewModel
    
    //MARK: - Initializers
    init(playlistURL: String) {
        self.viewModel = PlaylistViewModel(playlistURL: playlistURL)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        addDelegatesAndDataSources()
    }
    
    init(userPlaylist: UserPlaylist) {
        self.viewModel = PlaylistViewModel(userplaylist: userPlaylist)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        addDelegatesAndDataSources()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = playlistView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        playlistView.tableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        
        playlistView.tableView.dataSource = self
        playlistView.tableView.delegate = self
    }
    
}


extension PlaylistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tracks = viewModel.tracks {
            return tracks.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = playlistView.tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as! ProfileFavoriteTableViewCell
        
        if let tracks = viewModel.tracks {
            let track = tracks[indexPath.row]
            cell.updateUI(track: track)
        }
        return cell
        
    }
    
}

extension PlaylistVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tracks = viewModel.tracks {
            let track = tracks[indexPath.row]
            let vc = PlayerVC(track: track)
            vc.modalPresentationStyle = .pageSheet
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeTrack = UIContextualAction(style: .destructive,
                                             title: "Remove") { [weak self] action, view, bool in
            guard let self else { return }
            if let tracks = viewModel.tracks {
                let track = tracks[indexPath.row]
                viewModel.removeTrackFromPlaylist(track: track)
            }
        }
        return UISwipeActionsConfiguration(actions: [removeTrack])
    }
}


extension PlaylistVC: PlaylistViewModelDelegate {
    func updateUI() {
        playlistView.tableView.reloadData()
    }
}
