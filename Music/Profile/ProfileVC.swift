//
//  ProfileVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

final class ProfileVC: UIViewController {
    // MARK: - Properties
    lazy var  profielView = ProfileView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profielView
        profielView.tableView.dataSource = self
        configureSegmentedControll()
        configureNavigationBar()
    }
    
    //MARK: - UI Configuration
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureSegmentedControll(){
        profielView.segenmtedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    @objc func segmentValueChanged() {
        switch profielView.segenmtedControl.selectedSegmentIndex {
        case 0:
            profielView.tableView.register(ProfilePlayListTableViewCell.self, forCellReuseIdentifier: ProfilePlayListTableViewCell.reuseID)
            profielView.tableView.reloadData()
        case 1:
            profielView.tableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
            profielView.tableView.reloadData()
        default:
            break;
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch profielView.segenmtedControl.selectedSegmentIndex {
        case 0:
            guard let cell = profielView.tableView.dequeueReusableCell(withIdentifier: ProfilePlayListTableViewCell.reuseID, for: indexPath) as? ProfilePlayListTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        case 1:
            guard let cell = profielView.tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as? ProfileFavoriteTableViewCell else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }

    }
}
