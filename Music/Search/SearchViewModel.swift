//
//  SearchViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

protocol ChangeResultsProtocol: AnyObject{
    func changeResults(_ response: SearchTrackResponse)
}

class SearchViewModel: SearchViewModelProtocol {
    // MARK: - Propertires
    var data: SearchTrackResponse?
    weak var changeResultsProtocol: ChangeResultsProtocol?
    let manager = SearchSongManager(service: AlamofireService())
    var searchText = ""
    
    // MARK: - Functions
    func getData() {
        manager.getJsonData(searchText: self.searchText) { data in
            self.data = data
            if let data = data {
                self.changeResultsProtocol?.changeResults(data)
            }
        } onError: { error in
            print(error)
        }
    }
}

