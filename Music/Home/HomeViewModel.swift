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
    var view: HomeViewInterface? { get set }
}

protocol HomeViewModelDelegate: AnyObject {
    func updateUI()
}


final class HomeVM {
    weak var view: HomeViewInterface?
  
}

final class HomeViewModel: HomeViewModelProtocol {
  
    var radioResponse: RadioResponse?
    var genresResponse: GenresMusicResponse?
    var popularSongsResponse: RadioPlaylistResponse?
    let manager = DeezerAPIManager()
    weak var delegate: HomeViewModelDelegate?
    weak var view: HomeViewInterface?
    
    init() {
        getData()
        getDataGenres()
    }
    
    func showLoadingView() {
        view?.showLoadingIndicator()
       }
   
    func hideLoadingView() {
           view?.dismissLoadingIndicator()
       }
    
    func getData() {
        showLoadingView()
        manager.getRadioPlaylists { data in
            self.radioResponse = data
            self.getPopularSongs(playlistURL: data?.data?.first?.tracklist ?? "")
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
        hideLoadingView()
    }
    
    func getDataGenres() {
        showLoadingView()
        manager.getGenresLisits { data in
            self.genresResponse = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
        hideLoadingView()
    }
    
    func getPopularSongs(playlistURL: String) {
        showLoadingView()
        manager.getRadioPlaylist(playlistURL: playlistURL) { data in
            self.popularSongsResponse = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
        hideLoadingView()
    }
}
