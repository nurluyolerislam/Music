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

class SearchResultsVC: UIViewController {

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
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModelDelegate?.getData()
    }
    
    //MARK: - Helper Functionsı
    private func addDelegatesAndDataSources() {
        searchResultsView.searchResultsTableView.register(PopularSongsTableViewCell.self,
                                                          forCellReuseIdentifier: PopularSongsTableViewCell.reuseID)
        searchResultsView.searchResultsTableView.dataSource = self
        searchResultsView.searchResultsTableView.delegate = self
        
        viewModel.changeResultsProtocol = self
        viewModelDelegate = viewModel
    }
    
    private func addTargets() {
        searchResultsView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
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
    @objc func searchButtonTapped(){
        searchButtonDidTapped()
    }
    
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
        let cell = searchResultsView.searchResultsTableView.dequeueReusableCell(withIdentifier: PopularSongsTableViewCell.reuseID) as! PopularSongsTableViewCell
        
        if let response = viewModel.data {
            if let songs = response.data {
                cell.updateUI(track: songs[indexPath.row])
            }
        }
        
        return cell
    }
    
}

extension SearchResultsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let response = viewModel.data {
            if let songs = response.data {
                let song = songs[indexPath.row]
                if isPlaying {
                    player?.pause()
                    isPlaying.toggle()
                } else {
                    playAudio(url: URL(string: song.preview!)!)
                    isPlaying.toggle()
                }
            }
        }
    }
}

extension SearchResultsVC: SearchResultsViewProtocol {
    func searchButtonDidTapped() {
        self.viewModelDelegate?.getData()
    }
}

extension SearchResultsVC: ChangeResultsProtocol {
    func changeResults(_ response: SearchTrackResponse) {
        searchResultsView.searchResultsTableView.reloadData()
    }
}
