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
    func showProgressView()
    func dismissProgressView()
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
        delegate?.showProgressView()
        manager.getRadioPlaylists { data in
            self.radioResponse = data
            self.getPopularSongs(playlistURL: data?.data?.first?.tracklist ?? "")
            self.delegate?.updateUI()
            self.delegate?.dismissProgressView()
        } onError: { error in
            print(error)
            self.delegate?.dismissProgressView()
        }
    }
    
    func getDataGenres() {
        delegate?.showProgressView()
        manager.getGenresLisits { data in
            self.genresResponse = data
            self.delegate?.updateUI()
            self.delegate?.dismissProgressView()
        } onError: { error in
            print(error)
            self.delegate?.dismissProgressView()
        }
    }
    
    func getPopularSongs(playlistURL: String) {
        delegate?.showProgressView()
        manager.getRadioPlaylist(playlistURL: playlistURL) { data in
            self.popularSongsResponse = data
            self.delegate?.updateUI()
            self.delegate?.dismissProgressView()
        } onError: { error in
            print(error)
            self.delegate?.dismissProgressView()
        }
    }
}
