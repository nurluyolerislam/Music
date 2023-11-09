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
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profielView.tableView.dataSource = self
        view = profielView
        configureSegmentedControll()
     
     
    }
    
    //MARK: - UI Configuration
    
    private func configureSegmentedControll(){
        profielView.segenmtedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    @objc func segmentValueChanged() {
        switch profielView.segenmtedControl.selectedSegmentIndex {
         case 0:
            print("----->>>> DEBUG: 0")
            profielView.tableView.reloadData()
         case 1:
            print("----->>>> DEBUG: 1")
            profielView.tableView.reloadData()
         default:
             break;
         }
    }

}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAlbumTableViewCell.reuseID,
                                                       for: indexPath) as? ProfileAlbumTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}




