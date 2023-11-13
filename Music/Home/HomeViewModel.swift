//
//  HomeViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 11.11.2023.
//

protocol HomeViewModelProtocol: AnyObject {
    func getData()
    var data: RadioResponse? { get set }
    var dataGenres: GenresMusicResponse? { get set }
}

protocol HomeViewModelDelegate: AnyObject {
    func updateUI()
}

final class HomeViewModel: HomeViewModelProtocol {
    var data: RadioResponse?
    var dataGenres: GenresMusicResponse?
    let manager = DeezerAPIManager()
    weak var delegate: HomeViewModelDelegate?
    
    init() {
        getData()
        getDataGenres()
    }
    
    func getData() {
        manager.getRadioPlaylists { data in
            self.data = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }

    }
    
    func getDataGenres() {
        manager.getGenresLisits { data in
            self.dataGenres = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }
    }
}
