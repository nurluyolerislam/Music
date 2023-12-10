//
//  SearchViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

import Foundation

protocol ChangeResultsProtocol: AnyObject{
    func changeResults(_ response: SearchTrackResponse)
}

protocol SearchVMInterface: AnyObject{
    func viewDidLoad()
    func viewDidAppear()
    func SearchResultsVCDidSelectRow(at indexPath: IndexPath)
}


final class SearchViewModel: SearchViewModelProtocol {
    
    //MARK: - Properties
    var data: SearchTrackResponse?
    weak var changeResultsProtocol: ChangeResultsProtocol?
    private var view: SearcVCInterface?
    private let deezerAPIManager: DeezerAPIManagerProtocol
    private let firestoreManager: FirestoreManagerProtocol
    var searchText = ""
    var recentSearches: [String]?
    
    init(view: SearcVCInterface? ,deezerAPIManager: DeezerAPIManagerProtocol = DeezerAPIManager.shared, firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared) {
        self.view = view
        self.deezerAPIManager = deezerAPIManager
        self.firestoreManager = firestoreManager
    }
    
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
    
    private func getRecentSearches() {
        firestoreManager.getRecentSearches { [weak self] recentSearches in
            guard let self else { return }
            self.recentSearches = recentSearches
            view?.updateRecentSearches()
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



extension SearchViewModel: SearchVMInterface{
    func viewDidLoad() {
        view?.configureViewDidLoad()
    }
    
    func viewDidAppear() {
        getRecentSearches()
    }
    
    func SearchResultsVCDidSelectRow(at indexPath: IndexPath) {
        if let response = data {
            if let songs = response.data {
                let song = songs[indexPath.row]
                let vc = PlayerVC(track: song)
                vc.modalPresentationStyle = .pageSheet
                view?.presentVC(vc: vc)
            }
        }
    }
}
