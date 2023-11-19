//
//  SearchViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

protocol ChangeResultsProtocol: AnyObject{
    func changeResults(_ response: SearchTrackResponse)
}

protocol RecentSearchesDelegate: AnyObject {
    func updateRecentSearches()
}

final class SearchViewModel: SearchViewModelProtocol {
    
    //MARK: - Properties
    var data: SearchTrackResponse?
    weak var changeResultsProtocol: ChangeResultsProtocol?
    weak var recentSearchesDelegate: RecentSearchesDelegate?
    let deezerAPIManager = DeezerAPIManager()
    let firestoreManager = FirestoreManager()
    var searchText = ""
    var recentSearches: [String]?
    
    // MARK: - Functions
    func getData() {
        deezerAPIManager.getSearchResults(searchText: self.searchText) { [weak self] response in
            guard let self else { return }
            data = response
            if let response = response {
                self.changeResultsProtocol?.changeResults(response)
            }
        } onError: { error in
            print(error)
        }
    }
    
    func getRecentSearches() {
        firestoreManager.getRecentSearches { [weak self] recentSearches in
            guard let self else { return }
            self.recentSearches = recentSearches
            recentSearchesDelegate?.updateRecentSearches()
        } onError: { error in
            print(error)
        }
    }
    
    func updateRecentSearches(searchText: String) {
        firestoreManager.updateRecentSearches(searchText: searchText) { [weak self] in
            guard let self else { return }
            getRecentSearches()
        } onError: { error in
            print(error)
        }
    }
    
    func clearRecentSearches() {
        firestoreManager.clearRecentSearches { [weak self] in
            guard let self else { return }
            getRecentSearches()
        } onError: { error in
            print(error)
        }
    }
    
}

