//
//  SearchResultsVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit

class SearchResultsVC: UIViewController {
    //MARK: - Mocks
    let searchResults: [PopularSongsTableViewCellModel] = [
        .init(image: UIImage(named: "profileImage")!,
              songName: "Yerli Plaka - Ceza",
              albumName: "Yerli Plaka"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "On the top charts",
              albumName: "Recommended tracks by Alma"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas"),
        .init(image: UIImage(named: "profileImage")!,
              songName: "Enjoy together with friends",
              albumName: "Tunes by Jonas&Jonas")
    ]
    
    //MARK: - Variables
    lazy var searchResultsView = SearchResultsView()
    
    
    //MARK: - Lifecycle
    override func loadView() {
        view = searchResultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegatesAndDataSources()
    }
    
    //MARK: - Helper Functionsı
    private func addDelegatesAndDataSources() {
        searchResultsView.searchResultsTableView.register(PopularSongsTableViewCell.self,
                                                          forCellReuseIdentifier: PopularSongsTableViewCell.reuseID)
        searchResultsView.searchResultsTableView.dataSource = self
    }
}

extension SearchResultsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsView.searchResultsTableView.dequeueReusableCell(withIdentifier: PopularSongsTableViewCell.reuseID) as! PopularSongsTableViewCell
        let song = searchResults[indexPath.row]
        
        cell.songImageView.image = song.image
        cell.songNameLabel.text = song.songName
        cell.albumNameLabel.text = song.albumName
        
        return cell
    }
    
}
