//
//  RecentSearchesView.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

final class RecentSearchesView: UIView {
    
    //MARK: - UI Elements
    private lazy var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent searches"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var clearRecentSearchesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear All", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private lazy var headerStackView: UIStackView = {
        let spacer = UIView()
        let stack = UIStackView(arrangedSubviews: [
            recentSearchesLabel,
            spacer,
            clearRecentSearchesButton
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
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
        addSubviewsExt(headerStackView, recentSearchesTableView)
        configureHeaderStackView()
        configureRecentSearchesTableView()
    }
    
    private func configureHeaderStackView() {
        headerStackView.anchor(top: safeAreaLayoutGuide.topAnchor,
                               leading: safeAreaLayoutGuide.leadingAnchor,
                               trailing: safeAreaLayoutGuide.trailingAnchor,
                               padding: .init(leading: 20,
                                              trailing: 20))
    }
    
    private func configureRecentSearchesTableView() {
        recentSearchesTableView.anchor(top: recentSearchesLabel.bottomAnchor,
                                       leading: safeAreaLayoutGuide.leadingAnchor,
                                       bottom: safeAreaLayoutGuide.bottomAnchor,
                                       trailing: safeAreaLayoutGuide.trailingAnchor,
                                       padding: .init(top: 20,
                                                      leading: 20,
                                                      trailing: 20))
    }
}
