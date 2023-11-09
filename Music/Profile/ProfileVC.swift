//
//  ProfileVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

class ProfileVC: UIViewController {
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
            print("----->>>> DEBUG: 0")
            profielView.tableView.register(ProfileAlbumTableViewCell.self, forCellReuseIdentifier: ProfileAlbumTableViewCell.reuseID)
            profielView.tableView.reloadData()
        case 1:
            print("----->>>> DEBUG: 1")
            profielView.tableView.register(ProfileFavoreCell.self, forCellReuseIdentifier: ProfileFavoreCell.reuseID)
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
            guard let cell = profielView.tableView.dequeueReusableCell(withIdentifier: ProfileAlbumTableViewCell.reuseID, for: indexPath) as? ProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        case 1:
            guard let cell = profielView.tableView.dequeueReusableCell(withIdentifier: ProfileFavoreCell.reuseID, for: indexPath) as? ProfileFavoreCell else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }

    }
}
