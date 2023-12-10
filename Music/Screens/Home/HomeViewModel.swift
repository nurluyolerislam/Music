//
//  HomeViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 11.11.2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func viewDidLoad()
    func tableViewCellForItem(at indexPath: IndexPath) -> Track?
    func discoverCollectionViewCellForItem(at indexPath: IndexPath) -> Playlist?
    func genresCollectionViewCellForItem(at indexPath: IndexPath) -> GenresPlayList?
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
    let manager: DeezerAPIManagerProtocol
    private var view: HomeVCInterface?
    
    init(manager: DeezerAPIManagerProtocol = DeezerAPIManager.shared, view: HomeVCInterface?) {
        self.manager = manager
        self.view = view
    }
    
    private func getRadioPlaylists() {
        //view?.showProgressView()
        manager.getRadioPlaylists { data in
            self.radioResponse = data
            self.view?.reloadDiscoverCollectionView()
            self.getPopularSongs(playlistURL: data?.data?.first?.tracklist ?? "")
            // self.view?.dismissProgressView()
        } onError: { error in
            print(error)
            // self.view?.dismissProgressView()
        }
    }
    
    private func getGenres() {
        view?.showProgressView()
        manager.getGenresLists { data in
            self.genresResponse = data
            self.view?.reloadGenresCollectionView()
            self.view?.dismissProgressView()
        } onError: { error in
            print(error)
            self.view?.dismissProgressView()
        }
    }
    
    private func getPopularSongs(playlistURL: String) {
        //view?.showProgressView()
        manager.getRadioPlaylist(playlistURL: playlistURL) { data in
            self.popularSongsResponse = data
            self.view?.reloadTableView()
            // self.view?.dismissProgressView()
        } onError: { error in
            print(error)
            // self.view?.dismissProgressView()
        }
    }
    
}

extension HomeViewModel: HomeViewModelProtocol{
    
    func viewDidLoad() {
        view?.prepareTableView()
        view?.prepareDiscoverCollectionView()
        view?.prepareGenresCollectionView()
        view?.addTargets()
        view?.configureNavigationBar()
        getRadioPlaylists()
        getGenres()
    }
    
    func tableViewCellForItem(at indexPath: IndexPath) -> Track? {
        if let popularSongsResponse {
            if let tracks = popularSongsResponse.data {
                return tracks[indexPath.row]
            }
        }
        return nil
    }
    
    func discoverCollectionViewCellForItem(at indexPath: IndexPath) -> Playlist? {
        if let radioResponse {
            if let playlists = radioResponse.data {
                return playlists[indexPath.row]
            }
        }
        return nil
    }
    
    func genresCollectionViewCellForItem(at indexPath: IndexPath) -> GenresPlayList? {
        if let genresResponse {
            if let genresPlaylists = genresResponse.data {
                return genresPlaylists[indexPath.row]
            }
        }
        return nil
    }
    
    func discoverCollectionDidSelectItem(at indexPath: IndexPath) {
        if let response = radioResponse {
            if let playlists = response.data {
                let playlist = playlists[indexPath.row]
                
                if let playlistURL = playlist.tracklist {
                    let playlistVC = PlaylistVC(playlistURL: playlistURL)
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
                    let genresArtistsVC = GenreArtistsVC(genreId: genresID.description)
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
                    let playlistVC = PlaylistVC(playlistURL: playlistURL)
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
                    let genresVC = GenreArtistsVC(genreId: genreID.description)
                    genresVC.title = genre.name
                    view?.pushVC(vc: genresVC)
                }
            }
        }
    }
}
