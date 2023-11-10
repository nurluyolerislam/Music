//
//  SearchResultsView.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

protocol SearchResultsViewProtocol: AnyObject {
    func searchButtonDidTapped()
}

class SearchResultsView: UIView {
    
    //MARK: - UI Elements
    lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.configuration?.cornerStyle = .capsule
        button.setTitle("Search", for: .normal)
        button.tintColor = .label
        return button
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration Methods
    private func configureUI() {
        backgroundColor = .systemBackground
        configureSearchButton()
        configureSearchResultsTableView()
    }
    
    private func configureSearchButton() {
        addSubview(searchButton)
        searchButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                            leading: safeAreaLayoutGuide.leadingAnchor,
                            trailing: safeAreaLayoutGuide.trailingAnchor,
                            padding: .init(leading: 20,
                                           trailing: 20))
    }
    
    private func configureSearchResultsTableView() {
        addSubview(searchResultsTableView)
        searchResultsTableView.anchor(top: searchButton.bottomAnchor,
                                      leading: safeAreaLayoutGuide.leadingAnchor,
                                      bottom: safeAreaLayoutGuide.bottomAnchor,
                                      trailing: safeAreaLayoutGuide.trailingAnchor,
                                      padding: .init(leading: 20,
                                                     trailing: 20))
    }
}
