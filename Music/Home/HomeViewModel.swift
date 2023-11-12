//
//  HomeViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 11.11.2023.
//

protocol HomeViewModelProtocol: AnyObject {
    func getData()
    var data: RadioResponse? { get set }
}

protocol HomeViewModelDelegate: AnyObject {
    func updateUI()
}

final class HomeViewModel: HomeViewModelProtocol {
    var data: RadioResponse?
    let manager = DeezerAPIManager()
    weak var delegate: HomeViewModelDelegate?
    
    init() {
        getData()
    }
    
    func getData() {
        manager.getRadioPlaylists { data in
            self.data = data
            self.delegate?.updateUI()
        } onError: { error in
            print(error)
        }

    }
}
