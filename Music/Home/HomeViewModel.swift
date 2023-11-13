//
//  HomeViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 11.11.2023.
//

protocol HomeViewModelProtocol: AnyObject {
    func getData()
    var radioResponse: RadioResponse? { get set }
    var genresResponse: GenresMusicResponse? { get set }
    var popularSongsResponse: RadioPlaylistResponse? { get set }
}

protocol HomeViewModelDelegate: AnyObject {
    func updateUI()
}

final class HomeViewModel: HomeViewModelProtocol {
    var radioResponse: RadioResponse?
    var genresResponse: GenresMusicResponse?
    var popularSongsResponse: RadioPlaylistResponse?
    let manager = DeezerAPIManager()
    weak var delegate: HomeViewModelDelegate?
    
    init() {
        getData()
        getDataGenres()
    }
    
    func getData() {
        manager.getRadioPlaylists { data in
            self.radioResponse = data
            self.getPopularSongs(playlistURL: data?.data?.first?.tracklist ?? "")
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }

    }
    
    func getDataGenres() {
        manager.getGenresLisits { data in
            self.genresResponse = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
    }
    
    func getPopularSongs(playlistURL: String) {
        manager.getRadioPlaylist(playlistURL: playlistURL) { data in
            self.popularSongsResponse = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }

    }
}
