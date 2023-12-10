//
//  SearchResultsVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 9.11.2023.
//

import UIKit
import AVFoundation

protocol SearchViewModelProtocol: AnyObject {
    func getData()
    var data: SearchTrackResponse? { get set }
}

final class SearchResultsVC: UIViewController {

    //MARK: - Variables
    lazy var searchResultsView = SearchResultsView()
    private let viewModel: SearchViewModel
    weak var viewModelDelegate: SearchViewModelProtocol?
    var player: AVPlayer?
    var isPlaying = false
    
    //MARK: - Initializers
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        view = searchResultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegatesAndDataSources()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Helper Functionsı
    private func addDelegatesAndDataSources() {
        searchResultsView.searchResultsTableView.register(ProfileFavoriteTableViewCell.self,
                                                          forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        searchResultsView.searchResultsTableView.dataSource = self
        searchResultsView.searchResultsTableView.delegate = self
        
        viewModel.changeResultsProtocol = self
        viewModelDelegate = viewModel
    }
    
    // Bu fonksiyon, URL'yi alır ve onu çalmak için AVPlayer'ı yapılandırır.
    func playAudio(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Oynatma başladığında yapılan işlemler
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // AVPlayer'ı başlat
        player?.play()
    }
    
    //MARK: - @Actions
    
    // AVPlayer oynatmayı bitirdiğinde yapılacak işlemler
    @objc func playerDidFinishPlaying(note: NSNotification) {
        // Oynatma tamamlandığında buraya kod ekleyebilirsiniz
    }
    
}

extension SearchResultsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = viewModel.data {
            if let songs = response.data {
                return songs.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsView.searchResultsTableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID) as! ProfileFavoriteTableViewCell

        if let response = viewModel.data {
            if let tracks = response.data {
                let track = tracks[indexPath.row]
                cell.updateUI(track: track)
            }
        }
        return cell
    }
    
}

extension SearchResultsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.SearchResultsVCDidSelectRow(at: indexPath)
      
    }
}

extension SearchResultsVC: ChangeResultsProtocol {
    func changeResults(_ response: SearchTrackResponse) {
        searchResultsView.searchResultsTableView.reloadData()
    }
}
