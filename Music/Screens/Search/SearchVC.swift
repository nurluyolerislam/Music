//
//  SearchVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

final class SearchVC: UIViewController {
    
    //MARK: - Variables
    private lazy var recentSearchesView = RecentSearchesView()
    private lazy var viewModel = SearchViewModel()
    private lazy var workItem = WorkItem()
    
    //MARK: - UI Elements
    private lazy var searchController: UISearchController = {
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
        addTargets()
        configureNavigationBar()
        addDelegatesAndDataSources()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getRecentSearches()
    }
    
    
    //MARK: - Helper Functions
    private func addTargets() {
        recentSearchesView.clearRecentSearchesButton.addTarget(self, action: #selector(clearRecentSearchesButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Song Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func addDelegatesAndDataSources() {
        viewModel.recentSearchesDelegate = self
        recentSearchesView.recentSearchesTableView.dataSource = self
        recentSearchesView.recentSearchesTableView.delegate = self
    }
    
    @objc func clearRecentSearchesButtonTapped(){
        viewModel.clearRecentSearches()
    }
    
}

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        if query == "" {
            let resultVC = searchController.searchResultsController as! SearchResultsVC
            viewModel.data = nil
            resultVC.searchResultsView.searchResultsTableView.reloadData()
        } else {
            workItem.perform(after: 0.5) { [weak self] in
                guard let self else { return }
                viewModel.searchText = query
                viewModel.getData()
                viewModel.updateRecentSearches(searchText: query)
            }
        }
        
    }
    
}

extension SearchVC: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recentSearches = viewModel.recentSearches {
            return recentSearches.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let recentSearches = viewModel.recentSearches {
            let searchText = recentSearches[indexPath.row]
            cell.textLabel?.text = searchText
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let recentSearches = viewModel.recentSearches {
            let searchText = recentSearches[indexPath.row]
            searchController.searchBar.text = searchText
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
}


extension SearchVC: RecentSearchesDelegate {
    func updateRecentSearches() {
        recentSearchesView.recentSearchesTableView.reloadData()
    }
}
