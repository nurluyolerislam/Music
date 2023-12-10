//
//  GenreArtistsViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//

import Foundation

protocol GenreArtistsViewModelProtocol: AnyObject {
    var view: GenreArtistsVCInterface? { get set }
    func numberOfItemsInSection() -> Int
    func cellForItem(at indexPath: IndexPath) -> Artist?
    func didSelectItemAt(at indexPath: IndexPath)
}



final class GenreArtistsViewModel {

    var view: GenreArtistsVCInterface?
    private let genreId: String?
    private var data: GenresArtistListsResponse?
    private let manager: DeezerAPIManagerProtocol
    
    init(genreId: String?, manager: DeezerAPIManagerProtocol = DeezerAPIManager.shared) {
        self.genreId = genreId
        self.manager = manager
        getData()
    }
    
   private func getData() {
        manager.getGenresListsArtist(id: self.genreId!) { data in
            self.data = data
            self.view?.updateUI()
        } onError: { error in
            print(error)
        }

    }
    
}

extension GenreArtistsViewModel: GenreArtistsViewModelProtocol{
  
    func numberOfItemsInSection() -> Int {
        if let response = data {
            if let artists = response.data {
                return artists.count
            }
        }
        
        return 0
    }
    
    func cellForItem(at indexPath: IndexPath) -> Artist? {
    
            if let response = data {
                if let artists = response.data {
                    let artist = artists[indexPath.row]
                    return artist
                }
            }
        return nil
    }
    
    func didSelectItemAt(at indexPath: IndexPath) {
        if let response = data {
            if let artists = response.data {
                let artist = artists[indexPath.row]
                
                if let playlistURL = artist.tracklist {
                    let playlistVC = PlaylistVC(playlistURL: playlistURL)
                    playlistVC.title = artist.name
                    view?.pushVC(vc: playlistVC)
                }
            }
        }
    }
    
}
