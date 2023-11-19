//
//  PlaylistView.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit

final class PlaylistView: UIView {
    
    //MARK: - UI Elements
    lazy var tableView: UITableView = {
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
        configureTableView()
    }
    
    private func configureTableView() {
        addSubview(tableView)
        tableView.fillSuperview(padding: .init(leading: 10,
                                               trailing: 10))
    }

}
