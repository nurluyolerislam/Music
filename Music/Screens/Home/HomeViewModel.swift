//
//  HomeViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 11.11.2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func getData()
    func viewDidLoad()
    func discoverCollectionDidSelectItem(at indexPath: IndexPath)
    func genresCollectionDidSelectItem(at indexPath: IndexPath)
    func popularSongsDidSelectItem(at indexPath: IndexPath)
    func DiscoverVCDidSelectItem(at indexPath: IndexPath)
    func GenresVCDidSelectItem(at indexPath: IndexPath)
    func discoverVCnumberOfItemsInSection() -> Int
    func genresVCnumberOfItemsInSection() -> Int
    var radioResponse: RadioResponse? { get set }
    var genresResponse: GenresMusicResponse? { get set }
    var popularSongsResponse: RadioPlaylistResponse? { get set }
    
}

final class HomeViewModel {
    var radioResponse: RadioResponse?
    var genresResponse: GenresMusicResponse?
    var popularSongsResponse: RadioPlaylistResponse?
    let manager = DeezerAPIManager()
    private var view: HomeVCInterface?
    
    init(view: HomeVCInterface?) {
        self.view = view
    }
}

extension HomeViewModel: HomeViewModelProtocol{
    
    
    func viewDidLoad() {
        view?.configureViewDidLoad()
        getData()
        getDataGenres()
    }
    
    func discoverCollectionDidSelectItem(at indexPath: IndexPath) {
        if let response = radioResponse {
            if let playlists = response.data {
                let playlist = playlists[indexPath.row]
                
                if let playlistURL = playlist.tracklist {
                    let playlistVC = PlaylistVC(playlistURL: playlistURL, deezerAPIManager: manager)
                    playlistVC.title = playlist.title
                    view?.pushVC(vc: playlistVC)
                }
            }
        }
    }
    
    func genresCollectionDidSelectItem(at indexPath: IndexPath) {
        if let response = genresResponse {
            if let genres = response.data {
                let genre = genres[indexPath.row]
                
                if let genresID = genre.id {
                    let genresArtistsVC = GenreArtistsVC(genreId: genresID.description, manager: manager)
                    genresArtistsVC.title = genre.name
                    view?.pushVC(vc: genresArtistsVC)
                    
                }
            }
        }
    }
    
    func popularSongsDidSelectItem(at indexPath: IndexPath) {
        if let response = popularSongsResponse {
            if let songs = response.data {
                let song = songs[indexPath.row]
                let vc = PlayerVC(track: song)
                vc.modalPresentationStyle = .pageSheet
                view?.presentVC(vc: vc)
            }
        }
    }
    
    func discoverVCnumberOfItemsInSection() -> Int {
        if let response = radioResponse {
            if let playlists = response.data {
                return playlists.count
            }
        }
        return 0
    }
    
    func DiscoverVCDidSelectItem(at indexPath: IndexPath) {
        if let response = radioResponse {
            if let playlists = response.data {
                let playlist = playlists[indexPath.row]
                
                if let playlistURL = playlist.tracklist {
                    let playlistVC = PlaylistVC(playlistURL: playlistURL, deezerAPIManager: manager)
                    playlistVC.title = playlist.title
                    view?.pushVC(vc: playlistVC)
                }
            }
        }
    }
    
    func genresVCnumberOfItemsInSection() -> Int {
        if let response = genresResponse {
            if let genres = response.data {
                return genres.count
            }
        }
        return 0
    }
    
    func GenresVCDidSelectItem(at indexPath: IndexPath) {
        if let response = genresResponse {
            if let genres = response.data {
                let genre = genres[indexPath.row]
                
                if let genreID = genre.id {
                    let genresVC = GenreArtistsVC(genreId: genreID.description, manager: manager)
                    genresVC.title = genre.name
                    view?.pushVC(vc: genresVC)
                }
            }
        }
    }
    
    
    
    func getData() {
        //view?.showProgressView()
        manager.getRadioPlaylists { data in
            self.radioResponse = data
            self.getPopularSongs(playlistURL: data?.data?.first?.tracklist ?? "")
            self.view?.updateUI()
            // self.view?.dismissProgressView()
        } onError: { error in
            print(error)
            // self.view?.dismissProgressView()
        }
    }
    
    func getDataGenres() {
        view?.showProgressView()
        manager.getGenresLisits { data in
            self.genresResponse = data
            self.view?.updateUI()
            self.view?.dismissProgressView()
        } onError: { error in
            print(error)
            self.view?.dismissProgressView()
        }
    }
    
    func getPopularSongs(playlistURL: String) {
        //view?.showProgressView()
        manager.getRadioPlaylist(playlistURL: playlistURL) { data in
            self.popularSongsResponse = data
            self.view?.updateUI()
            // self.view?.dismissProgressView()
        } onError: { error in
            print(error)
            // self.view?.dismissProgressView()
        }
    }
}
