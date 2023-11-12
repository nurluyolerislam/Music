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
    
    //MARK: - Properties
    var data: SearchTrackResponse?
    weak var changeResultsProtocol: ChangeResultsProtocol?
    let manager = DeezerAPIManager()
    var searchText = ""
    
    // MARK: - Functions
    func getData() {
        manager.getSearchResults(searchText: self.searchText) { data in
            self.data = data
            if let data = data {
                self.changeResultsProtocol?.changeResults(data)
            }
        } onError: { error in
            print(error)
        }
    }
}

