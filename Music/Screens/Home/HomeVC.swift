//
//  HomeVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

protocol HomeVCInterface {
    func configureViewDidLoad()
    func updateUI()
    func showProgressView()
    func dismissProgressView()
    func pushVC(vc : UIViewController)
    func presentVC(vc : UIViewController)
}

final class HomeVC: UIViewController {
    
    //MARK: - Variables
    private lazy var homeView = HomeView()
    private lazy var viewModel = HomeViewModel(view: self)
    
    
    //MARK: - Lifecycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Configuration Methods
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Home"
    }
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        homeView.discoverCollectionView.register(MusicCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.genresCollectionView.register(MusicCollectionViewCell.self,
                                                     forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.popularSongsTableView.register(ProfileFavoriteTableViewCell.self,
                                                forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        
        homeView.discoverCollectionView.delegate = self
        homeView.genresCollectionView.delegate = self
        homeView.popularSongsTableView.delegate = self
        homeView.discoverCollectionView.dataSource = self
        homeView.genresCollectionView.dataSource = self
        homeView.popularSongsTableView.dataSource = self
    }
    
    
    //MARK: - Targets
    private func addTargets() {
        homeView.browseButton.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
        homeView.exploreButton.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - @Actions
    @objc private func browseButtonTapped() {
        let discoverVC = DiscoverVC(viewModel: viewModel)
        navigationController?.pushViewController(discoverVC, animated: true)
        
    }
    
    @objc private func exploreButtonTapped(){
        let genresVC = GenresVC(viewModel: viewModel)
        navigationController?.pushViewController(genresVC, animated: true)
    }
    
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let popularSongsResponse = viewModel.popularSongsResponse {
            if let tracks = popularSongsResponse.data {
                return tracks.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.popularSongsTableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as! ProfileFavoriteTableViewCell
        
        if let response = viewModel.popularSongsResponse {
            if let tracks = response.data {
                let track = tracks[indexPath.row]
                cell.updateUI(track: track)
            }
        }
        return cell
    }
    
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case homeView.discoverCollectionView:
            return 5
            
        case homeView.genresCollectionView:
            return 5
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case homeView.discoverCollectionView:
            let cell = homeView.discoverCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                           for: indexPath) as! MusicCollectionViewCell
            
            if let response = viewModel.radioResponse {
                if let playlists = response.data {
                    let playlist = playlists[indexPath.row]
                    cell.updateUI(playlist: playlist)
                }
            }
            
            return cell
            
        case homeView.genresCollectionView:
            let cell = homeView.genresCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                               
                                                                               for: indexPath) as! MusicCollectionViewCell
            
            if let response = viewModel.genresResponse {
                if let genresPlaylists = response.data {
                    let genresPlaylist = genresPlaylists[indexPath.row]
                    cell.updateUI(genresPlaylist: genresPlaylist)
                }
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case homeView.discoverCollectionView:
            viewModel.discoverCollectionDidSelectItem(at: indexPath)
            
        case homeView.genresCollectionView:
            viewModel.genresCollectionDidSelectItem(at: indexPath)
            
        default:
            return
        }
    }
    
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.popularSongsDidSelectItem(at: indexPath)
    }
}


extension HomeVC: HomeVCInterface{
    func configureViewDidLoad() {
        addTargets()
        addDelegatesAndDataSources()
        configureUI()
    }
    
    func showProgressView() {
        DispatchQueue.main.async {
            self.showLoading()
        }
    }
    
    func dismissProgressView() {
        dismissLoading()
    }
    
    func updateUI() {
        homeView.discoverCollectionView.reloadData()
        homeView.genresCollectionView.reloadData()
        homeView.popularSongsTableView.reloadData()
    }
    
    func pushVC(vc : UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentVC(vc: UIViewController) {
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
}
