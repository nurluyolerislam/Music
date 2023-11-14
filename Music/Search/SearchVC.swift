//
//  SearchVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

class SearchVC: UIViewController {
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getRecentSearches()
    }
    
    
    //MARK: - Helper Functions
    private func configureNavigationBar() {
        navigationItem.title = "Song Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func addDelegatesAndDataSources() {
        viewModel.recentSearchesDelegate = self
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
                viewModel.updateRecentSearches(searchText: query)
            }
        }
        
    }
    
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let searchText = viewModel.recentSearches[indexPath.row]
        
        cell.textLabel?.text = searchText
                
        return cell
    }
    
    
}


extension SearchVC: RecentSearchesDelegate {
    func updateRecentSearches() {
        recentSearchesView.recentSearchesTableView.reloadData()
    }
}
