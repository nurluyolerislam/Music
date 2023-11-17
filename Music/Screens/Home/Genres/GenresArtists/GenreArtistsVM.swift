//
//  GenreArtistsVM.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//

protocol GenreArtistsVMProtocol: AnyObject {
    func getData()
    var data: GenresArtistListsResponse? { get set }
}

protocol GenreArtistsVMDelegate: AnyObject {
    func updateUI()
}

final class GenreArtistsVM: GenreArtistsVMProtocol {
   
    let genreId: String
    var data: GenresArtistListsResponse?
    let manager: DeezerAPIManager
    weak var delegate: GenreArtistsVMDelegate?
    
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
