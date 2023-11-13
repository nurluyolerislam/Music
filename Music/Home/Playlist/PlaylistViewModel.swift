//
//  PlaylistViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 12.11.2023.
//

protocol PlaylistViewModelProtocol: AnyObject {
    func getData()
    var data: RadioPlaylistResponse? { get set }
}

protocol PlaylistViewModelDelegate: AnyObject {
    func updateUI()
}

final class PlaylistViewModel: PlaylistViewModelProtocol {
    let playlistURL: String
    var data: RadioPlaylistResponse?
    let manager: DeezerAPIManager
    weak var delegate: PlaylistViewModelDelegate?
    
    init(playlistURL: String, manager: DeezerAPIManager) {
        self.playlistURL = playlistURL
        self.manager = manager
        getData()
    }
    
    func getData() {
        manager.getRadioPlaylist(playlistURL: self.playlistURL) { data in
            self.data = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }

    }
}
