//
//  SearchVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

class SearchVC: UIViewController {
    
    //MARK: - Mocks
    let recentSearches: [SearchTableViewCellModel] = [
        .init(image: UIImage(named: "profileImage")!,
              songName: "Yerli Plaka - Ceza",
              albumName: "Yerli Plaka"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "On the top charts",
              albumName: "Recommended tracks by Alma"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas")
    ]
    
    //MARK: - Variables
    lazy var recentSearchesView = RecentSearchesView()
    lazy var viewModel = SearchViewModel()
    lazy var workItem = WorkItem()
    
    //MARK: - UI Elements
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsVC(viewModel: viewModel))
        searchController.searchBar.placeholder = "Search for songs, albums or artists"
        searchController.searchBar.backgroundImage = UIImage()
        return searchController
    }()
    
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = recentSearchesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addDelegatesAndDataSources()
    }
    
    //MARK: - Helper Functions
    private func configureNavigationBar() {
        navigationItem.title = "Song Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func addDelegatesAndDataSources() {
        recentSearchesView.recentSearchesTableView.register(SearchTableViewCell.self,
                                                          forCellReuseIdentifier: SearchTableViewCell.reuseID)
        recentSearchesView.recentSearchesTableView.dataSource = self
    }
    
}

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {return}
        if query == "" {
            let resultVC = searchController.searchResultsController as! SearchResultsVC
            viewModel.data = nil
            resultVC.searchResultsView.searchResultsTableView.reloadData()
        } else {
            workItem.perform(after: 0.5) { [weak self] in
                guard let self = self else { return }
                viewModel.searchText = query
                viewModel.getData()
            }
        }
        
    }
    
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentSearchesView.recentSearchesTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID) as! SearchTableViewCell
        let song = recentSearches[indexPath.row]
        
        cell.songImageView.image = song.image
        cell.songNameLabel.text = song.songName
        cell.albumNameLabel.text = song.albumName
        
        return cell
    }
    
    
}
