//
//  RecentSearchesView.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

class RecentSearchesView: UIView {
    
    //MARK: - UI Elements
    lazy var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent searches"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var recentSearchesTableView: UITableView = {
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
        configureRecentSearchesLabel()
        configureRecentSearchesTableView()
    }
    
    private func configureRecentSearchesLabel() {
        addSubview(recentSearchesLabel)
        recentSearchesLabel.anchor(top: safeAreaLayoutGuide.topAnchor,
                                   leading: safeAreaLayoutGuide.leadingAnchor,
                                   padding: .init(leading: 20))
    }
    
    private func configureRecentSearchesTableView() {
        addSubview(recentSearchesTableView)
        recentSearchesTableView.anchor(top: recentSearchesLabel.bottomAnchor,
                                       leading: safeAreaLayoutGuide.leadingAnchor,
                                       bottom: safeAreaLayoutGuide.bottomAnchor,
                                       trailing: safeAreaLayoutGuide.trailingAnchor,
                                       padding: .init(top: 20,
                                                      leading: 20,
                                                      trailing: 20))
    }
}
