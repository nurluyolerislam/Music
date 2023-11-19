//
//  GenreArtistsViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//

protocol GenreArtistsViewModelProtocol: AnyObject {
    func getData()
    var data: GenresArtistListsResponse? { get set }
}

protocol GenreArtistsViewModelDelegate: AnyObject {
    func updateUI()
}

final class GenreArtistsViewModel: GenreArtistsViewModelProtocol {
   
    let genreId: String
    var data: GenresArtistListsResponse?
    let manager: DeezerAPIManager
    weak var delegate: GenreArtistsViewModelDelegate?
    
    init(genreId: String, manager: DeezerAPIManager) {
        self.genreId = genreId
        self.manager = manager
        getData()
    }
    
    func getData() {
        manager.getGenresLisitsArtist(id: self.genreId) { data in
            self.data = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }

    }
}
