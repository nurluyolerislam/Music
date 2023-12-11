//
//  SearchViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

import Foundation

protocol SearchVMInterface: AnyObject{
    var searchResponse: SearchTrackResponse? { get set }
    var recentSearchesCount: Int { get }
    var searchResultsCount: Int { get }
    func loadView()
    func viewDidLoad()
    func viewDidAppear()
    func recentSearchesTableViewCellForRow(at indexPath: IndexPath) -> String
    func searchResultsTableViewDidSelectRow(at indexPath: IndexPath)
    func searchResultsTableViewCellForRow(at indexPath: IndexPath) -> Track?
    func clearRecentSearchesButtonTapped()
}

final class SearchViewModel {
    
    //MARK: - Properties
    var searchResponse: SearchTrackResponse?
    var recentSearches: [String] = []
    private var view: SearcVCInterface?
    private let deezerAPIManager: DeezerAPIManagerProtocol
    private let firestoreManager: FirestoreManagerProtocol
    private lazy var workItem = WorkItem()
    
    init(view: SearcVCInterface?,
         deezerAPIManager: DeezerAPIManagerProtocol = DeezerAPIManager.shared,
         firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared) {
        self.view = view
        self.deezerAPIManager = deezerAPIManager
        self.firestoreManager = firestoreManager
    }
    
    // MARK: - Functions
    func getSearchResults(searchText: String) {
        deezerAPIManager.getSearchResults(searchText: searchText) { [weak self] response in
            guard let self else { return }
            updateRecentSearches(searchText: searchText)
            searchResponse = response
            view?.reloadSearchResultsTableView()
        } onError: { error in
            print(error)
        }
    }
    
    private func getRecentSearches() {
        firestoreManager.getRecentSearches { [weak self] recentSearches in
            guard let self else { return }
            guard let recentSearches else { return }
            self.recentSearches = recentSearches
            view?.reloadRecentSearchesTableView()
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
    
}

extension SearchViewModel: SearchVMInterface{
    
    func recentSearchesTableViewCellForRow(at indexPath: IndexPath) -> String {
        return recentSearches[indexPath.row]
    }
    
    func searchResultsTableViewCellForRow(at indexPath: IndexPath) -> Track? {
        guard let searchResponse else { return nil }
        guard let tracks = searchResponse.data else { return nil }
        return tracks[indexPath.row]
    }
    
    var searchResultsCount: Int {
        guard let searchResponse else { return 0 }
        guard let tracks = searchResponse.data else { return 0 }
        return tracks.count
    }
    
    var recentSearchesCount: Int {
        recentSearches.count
    }
    
    
    func loadView() {
        view?.showRecentSearches()
    }
    
    func viewDidLoad() {
        view?.configureNavigationBar()
        view?.prepareRecentSearchesTableView()
        view?.prepareSearchResultsTableView()
        view?.addTargets()
    }
    
    func viewDidAppear() {
        getRecentSearches()
    }
    
    func updateSearchResults(searchText: String) {
        workItem.perform(after: 0.5) { [weak self] in
            guard let self else { return }
            if searchText.isEmpty {
                view?.showRecentSearches()
            } else {
                getSearchResults(searchText: searchText)
                view?.showResults()
            }
        }
    }
    
    func searchResultsTableViewDidSelectRow(at indexPath: IndexPath) {
        guard let searchResponse else { return }
        guard let songs = searchResponse.data else { return }
        let song = songs[indexPath.row]
        let vc = PlayerVC(track: song)
        vc.modalPresentationStyle = .pageSheet
        view?.presentVC(vc: vc)
    }
    
    @objc func clearRecentSearchesButtonTapped(){
        firestoreManager.clearRecentSearches { [weak self] in
            guard let self else { return }
            getRecentSearches()
        } onError: { error in
            print(error)
        }
    }
    
}
