//
//  SearchResultsView.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

class SearchResultsView: UIView {
    
    //MARK: - UI Elements
    lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
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
        configureSearchResultsTableView()
    }
    
    private func configureSearchResultsTableView() {
        addSubview(searchResultsTableView)
        searchResultsTableView.fillSuperview(padding: .init(leading: 20,
                                                            trailing: 20))
    }
}
