//
//  SearchVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

protocol SearcVCInterface {
    func configureNavigationBar()
    func addTargets()
    func prepareRecentSearchesTableView()
    func prepareSearchResultsTableView()
    func reloadRecentSearchesTableView()
    func reloadSearchResultsTableView()
    func showRecentSearches()
    func showResults()
    func presentVC(vc: UIViewController)
}

final class SearchVC: UIViewController {
    
    //MARK: - Variables
    private lazy var recentSearchesView = RecentSearchesView()
    private lazy var searchResultsView = SearchResultsView()
    private lazy var viewModel = SearchViewModel(view: self)
    
    
    //MARK: - UI Elements
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search for songs, albums or artists"
        searchController.searchBar.backgroundImage = UIImage()
        return searchController
    }()
    
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        viewModel.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.updateSearchResults(searchText: searchText)
    }
}

extension SearchVC: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case recentSearchesView.recentSearchesTableView: viewModel.recentSearchesCount
        case searchResultsView.searchResultsTableView: viewModel.searchResultsCount
        default: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recentSearchesView.recentSearchesTableView {
            let cell = UITableViewCell()
            cell.textLabel?.text = viewModel.recentSearchesTableViewCellForRow(at: indexPath)
            return cell
        }
        
        if tableView == searchResultsView.searchResultsTableView {
            guard let cell = searchResultsView.searchResultsTableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID) as? ProfileFavoriteTableViewCell else { return .init() }
            if let track = viewModel.searchResultsTableViewCellForRow(at: indexPath) {
                cell.updateUI(track: track)
                return cell
            }
        }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == recentSearchesView.recentSearchesTableView {
            let searchText = viewModel.recentSearches[indexPath.row]
            searchController.searchBar.text = searchText
            searchController.searchBar.becomeFirstResponder()
        }
        
        if tableView == searchResultsView.searchResultsTableView {
            viewModel.searchResultsTableViewDidSelectRow(at: indexPath)
        }
    }
    
}


extension SearchVC: SearcVCInterface {
    
    func showRecentSearches() {
        view = recentSearchesView
    }
    
    func showResults() {
        view = searchResultsView
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Song Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func addTargets() {
        recentSearchesView.clearRecentSearchesButton.addTarget(self, action: #selector(viewModel.clearRecentSearchesButtonTapped), for: .touchUpInside)
    }
    
    func prepareRecentSearchesTableView() {
        recentSearchesView.recentSearchesTableView.dataSource = self
        recentSearchesView.recentSearchesTableView.delegate = self
    }
    
    func prepareSearchResultsTableView() {
        searchResultsView.searchResultsTableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        searchResultsView.searchResultsTableView.dataSource = self
        searchResultsView.searchResultsTableView.delegate = self
    }
    
    func reloadRecentSearchesTableView() {
        recentSearchesView.recentSearchesTableView.reloadData()
    }
    
    func reloadSearchResultsTableView() {
        searchResultsView.searchResultsTableView.reloadData()
    }
    
    func presentVC(vc: UIViewController) {
        self.present(vc, animated: true)
    }
}
